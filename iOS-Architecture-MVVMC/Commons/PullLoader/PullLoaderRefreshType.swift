//
//  PullLoaderRefreshProtocol.swift
//
//

import Foundation
import UIKit

public enum PullLoaderRefreshViewState {
    case pullToRefresh
    case releaseToRefresh
    case refreshing
    case autoRefreshing
    case noMoreData
}

/**
 *  PullLoaderRefreshType
 *  Animation event handling callback protocol
 *  You can customize the refresh or custom animation effects
 *  Mutating is to be able to modify or enum struct variable in the method - http://swifter.tips/protocol-mutation/ by ONEVCAT
 */
public protocol PullLoaderRefreshType {

    /**
     Refresh operation begins execution method
     You can refresh your animation logic here, it will need to start the animation each time a refresh
    */
    mutating func refreshAnimationBegin(view: PullLoaderRefreshComponent)

    /**
     Refresh operation stop execution method
     Here you can reset your refresh control UI, such as a Stop UIImageView animations or some opened Timer refresh, etc., it will be executed once each time the need to end the animation
     */
    mutating func refreshAnimationEnd(view: PullLoaderRefreshComponent)

    /**
     Pulling status callback , progress is the percentage of the current offset with trigger, and avoid doing too many tasks in this process so as not to affect the fluency.
     */
    mutating func refresh(view: PullLoaderRefreshComponent, progressDidChange progress: CGFloat)

    mutating func refresh(view: PullLoaderRefreshComponent, stateDidChange state: PullLoaderRefreshViewState)
}

public protocol PullLoaderRefreshAnimatorType {

    // The view that called when component refresh, returns a custom view or self if 'self' is the customized views.
    var view: UIView { get }

    // Customized inset.
    var insets: UIEdgeInsets { get set }

    // Refresh event is executed threshold required y offset, set a value greater than 0.0, the default is 60.0
    var trigger: CGFloat { get set }

    // Offset y refresh event executed by this parameter you can customize the animation to perform when you refresh the view of reservations height
    var executeIncremental: CGFloat { get set }

    // Current refresh state, default is .pullToRefresh
    var state: PullLoaderRefreshViewState { get set }

}

/**
 *  PullLoaderRefreshImpacter
 *  Support iPhone7/iPhone7 Plus or later feedback impact
 *  You can confirm the PullLoaderRefreshImpacter
 */
private class PullLoaderRefreshImpacter {
    static private var impacter: AnyObject? = {
            if NSClassFromString("UIFeedbackGenerator") != nil {
                let generator = UIImpactFeedbackGenerator.init(style: .light)
                generator.prepare()
                return generator
            }
        return nil
    }()

    static public func impact() {
        if let impacter = impacter as? UIImpactFeedbackGenerator {
            impacter.impactOccurred()
        }
    }
}

public protocol ESRefreshImpactType {}
public extension ESRefreshImpactType {

    func impact() {
        PullLoaderRefreshImpacter.impact()
    }

}
