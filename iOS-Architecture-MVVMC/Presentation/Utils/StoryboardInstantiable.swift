//
//  StoryboardInstantiable.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation
import UIKit

public protocol StoryboardInstantiable: NSObjectProtocol {
    associatedtype AssociatedType
    static var defaultFileName: String { get }
    static func instantiateViewController(_ bundle: Bundle?) -> AssociatedType
}

public extension StoryboardInstantiable where Self: UIViewController {
    static var defaultFileName: String {
        return NSStringFromClass(Self.self).components(separatedBy: ".").last!
    }

    static func instantiateViewController(_ bundle: Bundle? = nil) -> Self {
        let fileName = defaultFileName
        let storyboard = UIStoryboard(name: fileName, bundle: bundle)
        guard let viewController = storyboard.instantiateInitialViewController() as? Self else {
            fatalError("Cannot instantiate initial view controller \(Self.self) from storyboard with name \(fileName)")
        }
        return viewController
    }
}
