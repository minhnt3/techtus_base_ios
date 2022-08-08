//
//  AnimalsCoordinator.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 13/07/2022.
//

import UIKit

class AnimalsCoordinator: BaseCoordinator {
    private weak var navigationController: UINavigationController?
    @Inject private var animalsViewController: AnimalsViewController
    @Inject private var animalsViewModel: AnimalViewModel

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        animalsViewController.bindViewModel(to: animalsViewModel)
        navigationController?.setViewControllers([animalsViewController], animated: true)
    }
}
