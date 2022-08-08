//
//  PullLoaderRefreshComponent.swift
//

import Foundation
import UIKit

public typealias PullLoaderRefreshHandler = (() -> Void)

open class PullLoaderRefreshComponent: UIView {

    open weak var scrollView: UIScrollView?

    /// @param handler Refresh callback method
    open var handler: PullLoaderRefreshHandler?

    /// @param animator Animated view refresh controls, custom must comply with the following two protocol
    open var animator: (PullLoaderRefreshType & PullLoaderRefreshAnimatorType)!

    /// @param refreshing or not
    fileprivate var _isRefreshing = false
    open var isRefreshing: Bool {
        return self._isRefreshing
    }

    /// @param auto refreshing or not
    fileprivate var _isAutoRefreshing = false
    open var isAutoRefreshing: Bool {
        return self._isAutoRefreshing
    }

    /// @param tag observing
    fileprivate var isObservingScrollView = false
    fileprivate var isIgnoreObserving = false

    public override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = [.flexibleLeftMargin, .flexibleWidth, .flexibleRightMargin]
    }

    public convenience init(frame: CGRect, handler: @escaping PullLoaderRefreshHandler) {
        self.init(frame: frame)
        self.handler = handler
        self.animator = PullLoaderRefreshAnimator()
    }

    public convenience init(frame: CGRect, handler: @escaping PullLoaderRefreshHandler, animator: PullLoaderRefreshType & PullLoaderRefreshAnimatorType) {
        self.init(frame: frame)
        self.handler = handler
        self.animator = animator
    }

    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        removeObserver()
    }

    open override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        /// Remove observer from superview immediately
        self.removeObserver()
        DispatchQueue.main.async { [weak self, newSuperview] in
            /// Add observer to new superview in next runloop
            self?.addObserver(newSuperview)
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.scrollView = self.superview as? UIScrollView
        let view = animator.view
        if view.superview == nil {
            let inset = animator.insets
            self.addSubview(view)
            view.frame = CGRect(x: inset.left,
                                y: inset.right,
                                width: self.bounds.size.width - inset.left - inset.right,
                                height: self.bounds.size.height - inset.top - inset.bottom)
            view.autoresizingMask = [
                .flexibleWidth,
                .flexibleTopMargin,
                .flexibleHeight,
                .flexibleBottomMargin
            ]
        }
    }

    // MARK: - Action

    public final func startRefreshing(isAuto: Bool = false) {
        guard isRefreshing == false && isAutoRefreshing == false else {
            return
        }

        _isRefreshing = !isAuto
        _isAutoRefreshing = isAuto

        self.start()
    }

    public final func stopRefreshing() {
        guard isRefreshing == true || isAutoRefreshing == true else {
            return
        }

        self.stop()
    }

    public func start() {

    }

    public func stop() {
        _isRefreshing = false
        _isAutoRefreshing = false
    }

    //  ScrollView contentSize change action
    public func sizeChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey: Any]?) {

    }

    //  ScrollView offset change action
    public func offsetChangeAction(object: AnyObject?, change: [NSKeyValueChangeKey: Any]?) {

    }

}

extension PullLoaderRefreshComponent /* KVO methods */ {

    fileprivate static var context = "ESRefreshKVOContext"
    fileprivate static let offsetKeyPath = "contentOffset"
    fileprivate static let contentSizeKeyPath = "contentSize"

    public func ignoreObserver(_ ignore: Bool = false) {
        if let scrollView = scrollView {
            scrollView.isScrollEnabled = !ignore
        }
        isIgnoreObserving = ignore
    }

    fileprivate func addObserver(_ view: UIView?) {
        if let scrollView = view as? UIScrollView, !isObservingScrollView {
            scrollView.addObserver(self, forKeyPath: PullLoaderRefreshComponent.offsetKeyPath, options: [.initial, .new], context: &PullLoaderRefreshComponent.context)
            scrollView.addObserver(self, forKeyPath: PullLoaderRefreshComponent.contentSizeKeyPath, options: [.initial, .new], context: &PullLoaderRefreshComponent.context)
            isObservingScrollView = true
        }
    }

    fileprivate func removeObserver() {
        if let scrollView = superview as? UIScrollView, isObservingScrollView {
            scrollView.removeObserver(self, forKeyPath: PullLoaderRefreshComponent.offsetKeyPath, context: &PullLoaderRefreshComponent.context)
            scrollView.removeObserver(self, forKeyPath: PullLoaderRefreshComponent.contentSizeKeyPath, context: &PullLoaderRefreshComponent.context)
            isObservingScrollView = false
        }
    }

    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
        if context == &PullLoaderRefreshComponent.context {
            guard isUserInteractionEnabled == true && isHidden == false else {
                return
            }
            if keyPath == PullLoaderRefreshComponent.contentSizeKeyPath {
                if isIgnoreObserving == false {
                    sizeChangeAction(object: object as AnyObject?, change: change)
                }
            } else if keyPath == PullLoaderRefreshComponent.offsetKeyPath {
                if isIgnoreObserving == false {
                    offsetChangeAction(object: object as AnyObject?, change: change)
                }
            }
        } else {

        }
    }

}
