//
//  ProfileCoordinator.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 24/05/2022.
//

import UIKit

protocol ProfileCoordinatorDependencies {
    func initProfileViewController(actions: ProfileViewModelNavigation) -> ProfileViewController
    func initAnimalsViewController() -> AnimalsViewController
}

class ProfileCoordinator: BaseCoordinator {

    private weak var navigationController: UINavigationController?
    @Inject private var profileViewController: ProfileViewController
    @Inject private var profileViewModel: ProfileViewModel
    @Inject private var animalsViewController: AnimalsViewController
    @Inject private var animalsViewModel: AnimalViewModel

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        profileViewModel.actions = self
        profileViewController.bindViewModel(to: profileViewModel)
        navigationController?.setViewControllers([profileViewController], animated: true)
    }
}

extension ProfileCoordinator: ProfileViewModelNavigation {
    func goToLogin() {
        parentCoordinator?.childDidFinish(self)
    }

    func goToAnimals() {
        animalsViewController.bindViewModel(to: animalsViewModel)
        navigationController?.pushViewController(animalsViewController, animated: true)
    }
}
