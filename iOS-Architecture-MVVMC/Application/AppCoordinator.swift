//
//  AppCoordinator.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation
import UIKit

protocol AppNavigation {
    func goToLoginScence()
    func goToMainScence()
}

class AppCoordinator: BaseCoordinator {

    private let navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        // Flow app we check at here, login success, init main - tabbar
        if AppData.isLogged {
            goToMainScence()
        } else {
            goToLoginScence()
        }
    }

    override func childDidFinish(_ coordinator: BaseCoordinator) {
        super.childDidFinish(coordinator)
        // Check isLogged
        if AppData.isLogged {
            goToMainScence()
        } else {
            goToLoginScence()
        }
    }
}

extension AppCoordinator: AppNavigation {
    func goToLoginScence() {
        let coordinator: LoginCoordinator = DependencyResolver.resolve(with: ["navigationController": navigationController])
        removeAllChildCoordinator()
        coordinator.parentCoordinator = self
        addChildCoordinator(coordinator)
        coordinator.start()
    }

    func goToMainScence() {
        let coordinator: MainCoordinator = DependencyResolver.resolve(with: ["navigationController": navigationController])
        removeAllChildCoordinator()
        coordinator.parentCoordinator = self
        coordinator.start()
    }
}
