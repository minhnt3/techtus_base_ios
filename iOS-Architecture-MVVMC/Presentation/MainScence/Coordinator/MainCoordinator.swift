//
//  MainCoordinator.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 24/05/2022.
//

import UIKit

class MainCoordinator: BaseCoordinator {

    private weak var navigationController: UINavigationController?
    @Inject private var mainTabbarViewController: MainTabbarViewController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        mainTabbarViewController.bindDependencies(parentCoordinator: parentCoordinator)
        navigationController?.setNavigationBarHidden(true, animated: true)
        navigationController?.setViewControllers([mainTabbarViewController], animated: true)
    }
}
