//
//  PullLoaderToRefresh.swift
//
//

import Foundation
import UIKit

private var kESRefreshHeaderKey: Void?
private var kESRefreshFooterKey: Void?

// swiftlint:disable file_length
public extension UIScrollView {

    /// Pull-to-refresh associated property
    var header: PullLoaderRefreshHeaderView? {
        get { return (objc_getAssociatedObject(self, &kESRefreshHeaderKey) as? PullLoaderRefreshHeaderView) }
        set(newValue) { objc_setAssociatedObject(self, &kESRefreshHeaderKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }

    /// Infinitiy scroll associated property
    var footer: ESRefreshFooterView? {
        get { return (objc_getAssociatedObject(self, &kESRefreshFooterKey) as? ESRefreshFooterView) }
        set(newValue) { objc_setAssociatedObject(self, &kESRefreshFooterKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN) }
    }
}

public extension PullLoader where Base: UIScrollView {
    /// Add pull-to-refresh
    @discardableResult
    func addPullToRefresh(handler: @escaping PullLoaderRefreshHandler) -> PullLoaderRefreshHeaderView {
        removeRefreshHeader()
        let header = PullLoaderRefreshHeaderView(frame: CGRect.zero, handler: handler)
        let headerH = header.animator.executeIncremental
        header.frame = CGRect(x: 0.0, y: -headerH /* - contentInset.top */, width: self.base.bounds.size.width, height: headerH)
        self.base.addSubview(header)
        self.base.header = header
        return header
    }

    @discardableResult
    func addPullToRefresh(animator: PullLoaderRefreshType & PullLoaderRefreshAnimatorType, handler: @escaping PullLoaderRefreshHandler) -> PullLoaderRefreshHeaderView {
        removeRefreshHeader()
        let header = PullLoaderRefreshHeaderView(frame: CGRect.zero, handler: handler, animator: animator)
        let headerH = animator.executeIncremental
        header.frame = CGRect(x: 0.0, y: -headerH /* - contentInset.top */, width: self.base.bounds.size.width, height: headerH)
        self.base.addSubview(header)
        self.base.header = header
        return header
    }

    /// Add infinite-scrolling
    @discardableResult
    func addInfiniteScrolling(handler: @escaping PullLoaderRefreshHandler) -> ESRefreshFooterView {
        removeRefreshFooter()
        let footer = ESRefreshFooterView(frame: CGRect.zero, handler: handler)
        let footerH = footer.animator.executeIncremental
        footer.frame = CGRect(x: 0.0, y: self.base.contentSize.height + self.base.contentInset.bottom, width: self.base.bounds.size.width, height: footerH)
        self.base.addSubview(footer)
        self.base.footer = footer
        return footer
    }

    @discardableResult
    func addInfiniteScrolling(animator: PullLoaderRefreshType & PullLoaderRefreshAnimatorType, handler: @escaping PullLoaderRefreshHandler) -> ESRefreshFooterView {
        removeRefreshFooter()
        let footer = ESRefreshFooterView(frame: CGRect.zero, handler: handler, animator: animator)
        let footerH = footer.animator.executeIncremental
        footer.frame = CGRect(x: 0.0, y: self.base.contentSize.height + self.base.contentInset.bottom, width: self.base.bounds.size.width, height: footerH)
        self.base.footer = footer
        self.base.addSubview(footer)
        return footer
    }

    /// Remove
    func removeRefreshHeader() {
        self.base.header?.stopRefreshing()
        self.base.header?.removeFromSuperview()
        self.base.header = nil
    }

    func removeRefreshFooter() {
        self.base.footer?.stopRefreshing()
        self.base.footer?.removeFromSuperview()
        self.base.footer = nil
    }

    /// Manual refresh
    func startPullToRefresh() {
        DispatchQueue.main.async { [weak base] in
            base?.header?.startRefreshing(isAuto: false)
        }
    }

    /// Auto refresh if expired.
    func autoPullToRefresh() {
        if self.base.expired == true {
            DispatchQueue.main.async { [weak base] in
                base?.header?.startRefreshing(isAuto: true)
            }
        }
    }

    /// Stop pull to refresh
    func stopPullToRefresh(ignoreDate: Bool = false, ignoreFooter: Bool = false) {
        self.base.header?.stopRefreshing()
        if ignoreDate == false {
            if let key = self.base.header?.refreshIdentifier {
                PullLoaderDataManager.sharedManager.setDate(Date(), forKey: key)
            }
            self.base.footer?.resetNoMoreData()
        }
        self.base.footer?.isHidden = ignoreFooter
    }

    /// Footer notice method
    func noticeNoMoreData() {
        self.base.footer?.stopRefreshing()
        self.base.footer?.noMoreData = true
        self.base.footer?.isHidden = true
    }

    func resetNoMoreData() {
        self.base.footer?.noMoreData = false
    }

    func stopLoadingMore() {
        self.base.footer?.stopRefreshing()
    }

}

public extension UIScrollView /* Date Manager */ {
    /// Identifier for cache expired timeinterval and last refresh date.
    var refreshIdentifier: String? {
        get { return self.header?.refreshIdentifier }
        set { self.header?.refreshIdentifier = newValue }
    }

    /// If you setted refreshIdentifier and expiredTimeInterval, return nearest refresh expired or not. Default is false.
    var expired: Bool {
        if let key = self.header?.refreshIdentifier {
            return PullLoaderDataManager.sharedManager.isExpired(forKey: key)
        }
        return false
    }

    var expiredTimeInterval: TimeInterval? {
        get {
            if let key = self.header?.refreshIdentifier {
                let interval = PullLoaderDataManager.sharedManager.expiredTimeInterval(forKey: key)
                return interval
            }
            return nil
        }
        set {
            if let key = self.header?.refreshIdentifier {
                PullLoaderDataManager.sharedManager.setExpiredTimeInterval(newValue, forKey: key)
            }
        }
    }

    /// Auto cached last refresh date when you setted refreshIdentifier.
    var lastRefreshDate: Date? {
        if let key = self.header?.refreshIdentifier {
            return PullLoaderDataManager.sharedManager.date(forKey: key)
        }
        return nil
    }

}

open class PullLoaderRefreshHeaderView: PullLoaderRefreshComponent {
    fileprivate var previousOffset: CGFloat = 0.0
    fileprivate var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    fileprivate var scrollViewBounces: Bool = true

    open var lastRefreshTimestamp: TimeInterval?
    open var refreshIdentifier: String?

    public convenience init(frame: CGRect, handler: @escaping PullLoaderRefreshHandler) {
        self.init(frame: frame)
        self.handler = handler
        self.animator = PullLoaderRefreshHeaderAnimator()
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async { [weak self] in
            self?.scrollViewBounces = self?.scrollView?.bounces ?? true
            self?.scrollViewInsets = self?.scrollView?.contentInset ?? UIEdgeInsets.zero
        }
    }

    open override func offsetChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey: Any]?) {
        guard let scrollView = scrollView else {
            return
        }

        super.offsetChangeAction(object: object, change: change)

        guard self.isRefreshing == false && self.isAutoRefreshing == false else {
            let top = scrollViewInsets.top
            let offsetY = scrollView.contentOffset.y
            let height = self.frame.size.height
            var scrollingTop = (-offsetY > top) ? -offsetY : top
            scrollingTop = (scrollingTop > height + top) ? (height + top) : scrollingTop

            scrollView.contentInset.top = scrollingTop

            return
        }

        // Check needs re-set animator's progress or not.
        var isRecordingProgress = false
        defer {
            if isRecordingProgress == true {
                let percent = -(previousOffset + scrollViewInsets.top) / self.animator.trigger
                self.animator.refresh(view: self, progressDidChange: percent)
            }
        }

        let offsets = previousOffset + scrollViewInsets.top
        if offsets < -self.animator.trigger {
            // Reached critical
            if isRefreshing == false && isAutoRefreshing == false {
                if scrollView.isDragging == false {
                    // Start to refresh...
                    self.startRefreshing(isAuto: false)
                    self.animator.refresh(view: self, stateDidChange: .refreshing)
                } else {
                    // Release to refresh! Please drop down hard...
                    self.animator.refresh(view: self, stateDidChange: .releaseToRefresh)
                    isRecordingProgress = true
                }
            }
        } else if offsets < 0 {
            // Pull to refresh!
            if isRefreshing == false && isAutoRefreshing == false {
                self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
                isRecordingProgress = true
            }
        } else {
            // Normal state
        }

        previousOffset = scrollView.contentOffset.y

    }

    open override func start() {
        guard let scrollView = scrollView else {
            return
        }
        // ignore observer
        self.ignoreObserver(true)
        // stop scroll view bounces for animation
        scrollView.bounces = false

        // call super start
        super.start()

        self.animator.refreshAnimationBegin(view: self)

        var insets = scrollView.contentInset
        self.scrollViewInsets.top = insets.top
        insets.top += animator.executeIncremental

        // We need to restore previous offset because we will animate scroll view insets and regular scroll view animating is not applied then.
        scrollView.contentInset = insets
        scrollView.contentOffset.y = previousOffset
        previousOffset -= animator.executeIncremental
        UIView.animate(withDuration: 0.2, delay: 0.0, options: .curveLinear, animations: {
            scrollView.contentOffset.y = -insets.top
        }, completion: { (_) in
            self.handler?()
            // un-ignore observer
            self.ignoreObserver(false)
            scrollView.bounces = self.scrollViewBounces
        })

    }

    open override func stop() {
        guard let scrollView = scrollView else {
            return
        }
        // ignore observer
        self.ignoreObserver(true)

        self.animator.refreshAnimationEnd(view: self)
        // Back state
        scrollView.contentInset.top = self.scrollViewInsets.top
        scrollView.contentOffset.y =  self.previousOffset
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            scrollView.contentOffset.y = -self.scrollViewInsets.top
        }, completion: { (_) in
            self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
            super.stop()
            scrollView.contentInset.top = self.scrollViewInsets.top
            self.previousOffset = scrollView.contentOffset.y
            // un-ignore observer
            self.ignoreObserver(false)
        })
    }

}

open class ESRefreshFooterView: PullLoaderRefreshComponent {
    fileprivate var scrollViewInsets: UIEdgeInsets = UIEdgeInsets.zero
    open var noMoreData = false {
        didSet {
            if noMoreData != oldValue {
                self.animator.refresh(view: self, stateDidChange: noMoreData ? .noMoreData : .pullToRefresh)
            }
        }
    }

    open override var isHidden: Bool {
        didSet {
            if isHidden == true {
                scrollView?.contentInset.bottom = scrollViewInsets.bottom
                var rect = self.frame
                rect.origin.y = scrollView?.contentSize.height ?? 0.0
                self.frame = rect
            } else {
                scrollView?.contentInset.bottom = scrollViewInsets.bottom + animator.executeIncremental
                var rect = self.frame
                rect.origin.y = scrollView?.contentSize.height ?? 0.0
                self.frame = rect
            }
        }
    }

    public convenience init(frame: CGRect, handler: @escaping PullLoaderRefreshHandler) {
        self.init(frame: frame)
        self.handler = handler
        self.animator = PullLoaderRefreshFooterAnimator()
    }

    /**
     In didMoveToSuperview, it will cache superview(UIScrollView)'s contentInset and update self's frame.
     It called ESRefreshComponent's didMoveToSuperview.
     */
    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        DispatchQueue.main.async { [weak self] in
            self?.scrollViewInsets = self?.scrollView?.contentInset ?? UIEdgeInsets.zero
            self?.scrollView?.contentInset.bottom = (self?.scrollViewInsets.bottom ?? 0) + (self?.bounds.size.height ?? 0)
            var rect = self?.frame ?? CGRect.zero
            rect.origin.y = self?.scrollView?.contentSize.height ?? 0.0
            self?.frame = rect
        }
    }

    open override func sizeChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey: Any]?) {
        guard let scrollView = scrollView else { return }
        super.sizeChangeAction(object: object, change: change)
        let targetY = scrollView.contentSize.height + scrollViewInsets.bottom
        if self.frame.origin.y != targetY {
            var rect = self.frame
            rect.origin.y = targetY
            self.frame = rect
        }
    }

    open override func offsetChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey: Any]?) {
        guard let scrollView = scrollView else {
            return
        }
        super.offsetChangeAction(object: object, change: change)

        guard isRefreshing == false && isAutoRefreshing == false && noMoreData == false && isHidden == false else {
            return
        }

        if scrollView.contentSize.height <= 0.0 || scrollView.contentOffset.y + scrollView.contentInset.top <= 0.0 {
            self.alpha = 0.0
            return
        } else {
            self.alpha = 1.0
        }

        if scrollView.contentSize.height + scrollView.contentInset.top > scrollView.bounds.size.height {
            // The content exceeds one screen Calculate the formula to determine whether it is dragged to the bottom
            if scrollView.contentSize.height - scrollView.contentOffset.y + scrollView.contentInset.bottom  <= scrollView.bounds.size.height {
                self.animator.refresh(view: self, stateDidChange: .refreshing)
                self.startRefreshing()
            }
        } else {
            // The content does not exceed one screen. At this time, the dragging height is greater than 1/2footer, which means that the pull-up is requested.
            if scrollView.contentOffset.y + scrollView.contentInset.top >= animator.trigger / 2.0 {
                self.animator.refresh(view: self, stateDidChange: .refreshing)
                self.startRefreshing()
            }
        }
    }

    open override func start() {
        guard let scrollView = scrollView else {
            return
        }
        super.start()
        self.animator.refreshAnimationBegin(view: self)

        let xOffset = scrollView.contentOffset.x
        let yOffset = max(0.0, scrollView.contentSize.height - scrollView.bounds.size.height + scrollView.contentInset.bottom)

        // Call handler
        UIView.animate(withDuration: 0.3, delay: 0.0, options: .curveLinear, animations: {
            scrollView.contentOffset = CGPoint(x: xOffset, y: yOffset)
        }, completion: { (_) in
            self.handler?()
        })
    }

    open override func stop() {
        guard let scrollView = scrollView else {
            return
        }
        self.animator.refreshAnimationEnd(view: self)

        // Back state
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear, animations: {
        }, completion: { (_) in
            if self.noMoreData == false {
                self.animator.refresh(view: self, stateDidChange: .pullToRefresh)
            }
            super.stop()
        })
        // Stop deceleration of UIScrollView. When the button tap event is caught, you read what the [scrollView contentOffset].x is, and set the offset to this value with animation OFF.
        // http://stackoverflow.com/questions/2037892/stop-deceleration-of-uiscrollview
        if scrollView.isDecelerating {
            var contentOffset = scrollView.contentOffset
            contentOffset.y = min(contentOffset.y, scrollView.contentSize.height - scrollView.frame.size.height)
            if contentOffset.y < 0.0 {
                contentOffset.y = 0.0
                UIView.animate(withDuration: 0.1, animations: {
                    scrollView.setContentOffset(contentOffset, animated: false)
                })
            } else {
                scrollView.setContentOffset(contentOffset, animated: false)
            }
        }
    }
    /// Change to no-more-data status.
    open func noticeNoMoreData() {
        self.noMoreData = true
    }
    /// Reset no-more-data status.
    open func resetNoMoreData() {
        self.noMoreData = false
    }
}
