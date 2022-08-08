//
//  PullLoaderRefreshFooterAnimator.swift
//
//

import UIKit

open class PullLoaderRefreshFooterAnimator: UIView, PullLoaderRefreshType, PullLoaderRefreshAnimatorType {

    open var loadingMoreDescription: String = PullLoaderConstants.PullLoaderText.loadingMoreDescription
    open var noMoreDataDescription: String = PullLoaderConstants.PullLoaderText.noMoreDataDescription
    open var loadingDescription: String = PullLoaderConstants.PullLoaderText.loadingDescription

    open var view: UIView { return self }
    open var duration: TimeInterval = 0.3
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var trigger: CGFloat = 42.0
    open var executeIncremental: CGFloat = 42.0
    open var state: PullLoaderRefreshViewState = .pullToRefresh

    fileprivate let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 160.0 / 255.0, alpha: 1.0)
        label.textAlignment = .center
        return label
    }()

    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.isHidden = true
        return indicatorView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = loadingMoreDescription
        addSubview(titleLabel)
        addSubview(indicatorView)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func refreshAnimationBegin(view: PullLoaderRefreshComponent) {
        indicatorView.startAnimating()
        titleLabel.text = loadingDescription
        indicatorView.isHidden = false
    }

    open func refreshAnimationEnd(view: PullLoaderRefreshComponent) {
        indicatorView.stopAnimating()
        titleLabel.text = loadingMoreDescription
        indicatorView.isHidden = true
    }

    open func refresh(view: PullLoaderRefreshComponent, progressDidChange progress: CGFloat) {
        // do nothing
    }

    open func refresh(view: PullLoaderRefreshComponent, stateDidChange state: PullLoaderRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state

        switch state {
        case .refreshing, .autoRefreshing :
            titleLabel.text = loadingDescription
        case .noMoreData:
            titleLabel.text = ""
        case .pullToRefresh:
            titleLabel.text = loadingMoreDescription
        default:
            break
        }
        self.setNeedsLayout()
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let size = self.bounds.size
        let width = size.width
        let height = size.height

        titleLabel.sizeToFit()
        titleLabel.center = CGPoint(x: width / 2.0, y: height / 2.0 - 5.0)
        indicatorView.center = CGPoint(x: titleLabel.frame.origin.x - 18.0, y: titleLabel.center.y)
    }
}
