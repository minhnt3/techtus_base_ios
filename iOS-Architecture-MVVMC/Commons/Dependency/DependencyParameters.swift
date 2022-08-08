//
//  DependencyParameters.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/07/12.
//

import Foundation

// Generic parameters bundle which can be passed to a dependency as input
public typealias DependencyParameters = [String: Any?]
// empty dependency parameters
public let defaultDependencyParameters: DependencyParameters = [:]
