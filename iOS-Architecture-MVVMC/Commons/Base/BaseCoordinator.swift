//
//  BaseCoordinator.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 24/05/2022.
//

import Foundation

protocol Coordinator {
    var childCoordinators: [BaseCoordinator] { get set }
    var parentCoordinator: BaseCoordinator? { get set }
    func start()
    func childDidFinish(_ coordinator: BaseCoordinator)
}

class BaseCoordinator: Coordinator {
    var childCoordinators: [BaseCoordinator] = []
    weak var parentCoordinator: BaseCoordinator?
    func start() {}
    func childDidFinish(_ coordinator: BaseCoordinator) {
        removeChildCoordinator(coordinator)
    }
}

extension BaseCoordinator {
    func addChildCoordinator(_ coordinator: BaseCoordinator) {
        childCoordinators.append(coordinator)
    }
    func removeChildCoordinator(_ coordinator: BaseCoordinator) {
        if let index = childCoordinators.firstIndex(of: coordinator) {
            childCoordinators.remove(at: index)
        } else {
            print("Colldn't remove coordinator: \(coordinator). It's not a child coordinator.")
        }
    }
    func removeAllChildCoordinatorWith<T>(type: T.Type) {
        childCoordinators = childCoordinators.filter {$0 is T == false }
    }
    func removeAllChildCoordinator() {
        childCoordinators.removeAll()
    }
}

extension BaseCoordinator: Equatable {
    static func == (lhs: BaseCoordinator, rhs: BaseCoordinator) -> Bool {
        return lhs.childCoordinators == rhs.childCoordinators && lhs.parentCoordinator == lhs.parentCoordinator
    }
}
