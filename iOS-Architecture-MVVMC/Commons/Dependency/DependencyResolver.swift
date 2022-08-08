//
//  DependencyResolver.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/07/12.
//

import Foundation
public class DependencyResolver {

    private static var dependencyDefinitions = [String: DependencyDefinition]()
    private static var dependencyDefinitionsWithParameters = [String: DependencyDefinitionWithParameters]()
    private static var sharedInstances = [String: Any]()

    private init() {}

    public static func register(_ closure: @escaping (DependencyRegistrar) -> Void) {
        DependencyRegistrar().apply(closure)
    }

    public static func register<Dependency>(type: Dependency.Type, resolutionStrategy: DependencyResolutionStrategy, initializer: @escaping () -> Dependency) {
        let key = keyFor(type: type)
        self.dependencyDefinitions[key] = DependencyDefinition(resolutionStrategy: resolutionStrategy, initializer: initializer)
    }

    public static func register<Dependency>(type: Dependency.Type, resolutionStrategy: DependencyResolutionStrategy, initializer: @escaping (DependencyParameters) -> Dependency) {
        let key = keyFor(type: type)
        self.dependencyDefinitionsWithParameters[key] = DependencyDefinitionWithParameters(resolutionStrategy: resolutionStrategy, initializer: initializer)
    }

    /// Automagically resolve a dependency based on the returned type.
    public static func resolve<Dependency>() -> Dependency {
        let key = keyFor(type: Dependency.self)
        guard let dependencyDefinition = self.dependencyDefinitions[key] else {
            fatalError("\(key) has not been added as an injectable object.")
        }
        switch dependencyDefinition.resolutionStrategy {
        case .factory:
            if let dependency = dependencyDefinition.initializer() as? Dependency {
                return dependency
            } else {
                fatalError("Could not instantiate an object for \(key).")
            }

        case .singleton:
            if let dependency = self.sharedInstances[key] as? Dependency {
                return dependency
            } else if let dependency = dependencyDefinition.initializer() as? Dependency {
                self.sharedInstances[key] = dependency
                return dependency
            } else {
                fatalError("Could not instantiate an object for \(key).")
            }
        }
    }

    /// Automagically resolve a dependency with parameters based on the returned type.
    public static func resolve<Dependency>(with parameters: DependencyParameters) -> Dependency {
        let key = keyFor(type: Dependency.self)
        guard let dependencyDefinition = self.dependencyDefinitionsWithParameters[key] else {
            fatalError("\(key) has not been added as an injectable object.")
        }
        switch dependencyDefinition.resolutionStrategy {
        case .factory:
            if let dependency = dependencyDefinition.initializer(parameters) as? Dependency {
                return dependency
            } else {
                fatalError("Could not instantiate an object for \(key).")
            }

        case .singleton:
            if let dependency = self.sharedInstances[key] as? Dependency {
                return dependency
            } else if let dependency = dependencyDefinition.initializer(parameters) as? Dependency {
                self.sharedInstances[key] = dependency
                return dependency
            } else {
                fatalError("Could not instantiate an object for \(key).")
            }
        }
    }

    /// Clear all dependency registrations.
    public static func clear() {
        dependencyDefinitions = [:]
        dependencyDefinitionsWithParameters = [:]
        sharedInstances = [:]
    }

    private static func keyFor<Dependency>(type: Dependency.Type) -> String {
        if let wrappedType = type as? OptionalProtocol.Type {
            return String(reflecting: wrappedType.wrappedType)
        } else {
            return String(reflecting: type)
        }
    }
}

protocol OptionalProtocol {
    static var wrappedType: Any.Type { get }
}

extension Optional: OptionalProtocol {
    static var wrappedType: Any.Type { return Wrapped.self }
}
