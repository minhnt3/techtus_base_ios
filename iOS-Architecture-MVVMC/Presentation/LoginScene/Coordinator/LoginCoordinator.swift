//
//  LoginCoordinator.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import UIKit

class LoginCoordinator: BaseCoordinator {

    private weak var navigationController: UINavigationController?
    @Inject private var loginViewController: LoginViewController
    @Inject private var loginViewModel: LoginViewModel

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    override func start() {
        loginViewModel.actions = self
        loginViewController.bindViewModel(to: loginViewModel)
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}

extension LoginCoordinator: LoginViewModelNavigation {

    func goBack() {
        navigationController?.popViewController(animated: true)
    }

    func goToMainScence() {
        parentCoordinator?.childDidFinish(self)
    }

}
