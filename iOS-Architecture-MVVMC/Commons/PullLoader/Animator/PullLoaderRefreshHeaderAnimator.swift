//
//  PullLoaderRefreshHeaderView.swift
//
//

import Foundation
import QuartzCore
import UIKit

open class PullLoaderRefreshHeaderAnimator: UIView, PullLoaderRefreshType, PullLoaderRefreshAnimatorType, ESRefreshImpactType {
    open var pullToRefreshDescription = PullLoaderConstants.PullLoaderText.pullToRefreshDescription {
        didSet {
            if pullToRefreshDescription != oldValue {
                titleLabel.text = pullToRefreshDescription
            }
        }
    }
    open var releaseToRefreshDescription = PullLoaderConstants.PullLoaderText.releaseToRefreshDescription
    open var loadingDescription = PullLoaderConstants.PullLoaderText.loadingDescription

    open var view: UIView { return self }
    open var insets: UIEdgeInsets = UIEdgeInsets.zero
    open var trigger: CGFloat = 60.0
    open var executeIncremental: CGFloat = 60.0
    open var state: PullLoaderRefreshViewState = .pullToRefresh

    fileprivate let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: PullLoaderConstants.PullLoaderImage.iconPullToRefreshArrow)
        return imageView
    }()

    fileprivate let titleLabel: UILabel = {
        let label = UILabel(frame: CGRect.zero)
        label.font = UIFont.systemFont(ofSize: 14.0)
        label.textColor = UIColor(white: 0.625, alpha: 1.0)
        label.textAlignment = .left
        return label
    }()

    fileprivate let indicatorView: UIActivityIndicatorView = {
        let indicatorView = UIActivityIndicatorView()
        indicatorView.isHidden = true
        return indicatorView
    }()

    public override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = pullToRefreshDescription
        self.addSubview(imageView)
        self.addSubview(titleLabel)
        self.addSubview(indicatorView)
    }

    public required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open func refreshAnimationBegin(view: PullLoaderRefreshComponent) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        imageView.isHidden = true
        titleLabel.text = loadingDescription
        imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
    }

    open func refreshAnimationEnd(view: PullLoaderRefreshComponent) {
        indicatorView.stopAnimating()
        indicatorView.isHidden = true
        imageView.isHidden = false
        titleLabel.text = pullToRefreshDescription
        imageView.transform = CGAffineTransform.identity
    }

    open func refresh(view: PullLoaderRefreshComponent, progressDidChange progress: CGFloat) {
        // Do nothing
    }

    open func refresh(view: PullLoaderRefreshComponent, stateDidChange state: PullLoaderRefreshViewState) {
        guard self.state != state else {
            return
        }
        self.state = state

        switch state {
        case .refreshing, .autoRefreshing:
            titleLabel.text = loadingDescription
            self.setNeedsLayout()
        case .releaseToRefresh:
            titleLabel.text = releaseToRefreshDescription
            self.setNeedsLayout()
            self.impact()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: { [weak self] in
                self?.imageView.transform = CGAffineTransform(rotationAngle: 0.000001 - CGFloat.pi)
            })
        case .pullToRefresh:
            titleLabel.text = pullToRefreshDescription
            self.setNeedsLayout()
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIView.AnimationOptions(), animations: { [weak self] in
                self?.imageView.transform = CGAffineTransform.identity
            })
        default:
            break
        }
    }

    open override func layoutSubviews() {
        super.layoutSubviews()
        let size = self.bounds.size
        let width = size.width
        let height = size.height

        UIView.performWithoutAnimation {
            titleLabel.sizeToFit()
            titleLabel.center = CGPoint(x: width / 2.0, y: height / 2.0)
            indicatorView.center = CGPoint(x: titleLabel.frame.origin.x - 16.0, y: height / 2.0)
            imageView.frame = CGRect(x: titleLabel.frame.origin.x - 28.0, y: (height - 18.0) / 2.0, width: 18.0, height: 18.0)
        }
    }

}
