//
//  DependencyDefinition.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/07/12.
//

public enum DependencyResolutionStrategy {
    /// Dependency will be recreated every time it's injected.
    case factory
    /// There will be only one instance of the dependency class.
    case singleton
}

/**
 Definition of a dependency when it's registered in the resolver.
 */
struct DependencyDefinition {
    let resolutionStrategy: DependencyResolutionStrategy
    let initializer: DependencyInitializer
}

/**
Definition of a dependency with parameters when it's registered in the resolver.
*/
struct DependencyDefinitionWithParameters {
    let resolutionStrategy: DependencyResolutionStrategy
    let initializer: DependencyInitializerWithParameters
}

typealias DependencyInitializer = () -> Any
typealias DependencyInitializerWithParameters = (DependencyParameters) -> Any
