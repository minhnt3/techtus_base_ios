//
//  PullLoader.swift
//  ESPullToRefreshExample
//
//

import UIKit

public protocol PullLoaderExtensionsProvider: AnyObject {
    associatedtype CompatibleType
    var pullLoader: CompatibleType { get }
}

extension PullLoaderExtensionsProvider {
    /// A proxy which hosts reactive extensions for `self`.
    public var pullLoader: PullLoader<Self> {
        return PullLoader(self)
    }

}

public struct PullLoader<Base> {
    public let base: Base

    // Construct a proxy.
    //
    // - parameters:
    //   - base: The object to be proxied.
    fileprivate init(_ base: Base) {
        self.base = base
    }
}

// 
extension UIScrollView: PullLoaderExtensionsProvider {}
