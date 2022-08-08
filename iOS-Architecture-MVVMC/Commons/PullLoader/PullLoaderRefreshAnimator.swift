//
//  PullLoaderRefreshAnimator.swift
//
//

import Foundation
import UIKit

open class PullLoaderRefreshAnimator: PullLoaderRefreshType, PullLoaderRefreshAnimatorType {
    // The view that called when component refresh, returns a custom view or self if 'self' is the customized views.
    open var view: UIView
    // Customized inset.
    open var insets: UIEdgeInsets
    // Refresh event is executed threshold required y offset, set a value greater than 0.0, the default is 60.0
    open var trigger: CGFloat = 60.0
    // Offset y refresh event executed by this parameter you can customize the animation to perform when you refresh the view of reservations height
    open var executeIncremental: CGFloat = 60.0
    // Current refresh state, default is .pullToRefresh
    open var state: PullLoaderRefreshViewState = .pullToRefresh

    public init() {
        view = UIView()
        insets = UIEdgeInsets.zero
    }

    open func refreshAnimationBegin(view: PullLoaderRefreshComponent) {
    }

    open func refreshAnimationWillEnd(view: PullLoaderRefreshComponent) {
    }

    open func refreshAnimationEnd(view: PullLoaderRefreshComponent) {
    }

    open func refresh(view: PullLoaderRefreshComponent, progressDidChange progress: CGFloat) {

    }

    open func refresh(view: PullLoaderRefreshComponent, stateDidChange state: PullLoaderRefreshViewState) {

    }
}
