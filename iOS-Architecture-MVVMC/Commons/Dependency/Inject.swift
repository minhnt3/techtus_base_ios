//
//  Inject.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/07/12.
//

import Foundation
import UIKit

@propertyWrapper
public struct Inject<T> {
    private var valueHolder: T?
    private let parameters: DependencyParameters

    public var wrappedValue: T {
        mutating get {
            if let value = valueHolder {
                return value
            } else {
                let value: T = parameters.isEmpty ? DependencyResolver.resolve() : DependencyResolver.resolve(with: parameters)
                valueHolder = value
                return value
            }
        }
    }

    public init(with parameters: DependencyParameters = defaultDependencyParameters) {
        self.parameters = parameters
    }
}
