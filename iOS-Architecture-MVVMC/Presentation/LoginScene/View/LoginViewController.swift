//
//  LoginViewController.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import UIKit

class LoginViewController: BaseViewController<LoginViewModel> {
    @IBOutlet weak var userNameTextfield: BaseTextField!
    @IBOutlet weak var passwordTextfield: UITextField!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var passwordLabel: UILabel!
    @IBOutlet weak var titleViewLabel: UILabel!
    @IBOutlet weak var loginButton: BaseButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        print(Environment.baseUrl)
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func setupLanguagueText() {
        userNameLabel.text = Strings.LoginScreen.userNameLabel
        passwordLabel.text = Strings.LoginScreen.passwordLabel
        titleViewLabel.text = Strings.LoginScreen.titleLabel
        loginButton.setTitle(Strings.LoginScreen.loginButton, for: .normal)
    }

    override func bindViewModel() {
        super.bindViewModel()
        userNameTextfield.onRightImageTap = {
            print("Right image")
        }
        loginButton.onPressed = { [weak self] _ in
            let userName = self?.userNameTextfield.text ?? ""
            let password = self?.passwordTextfield.text ?? ""
            self?.viewModel.doLogin(userName: userName, password: password)
        }
        viewModel.usernameMessageValid.observe(on: self) { [weak self] usernameMessage in
            if let usernameMessage = usernameMessage {
                let alert = AlertModel(title: "",
                                       message: usernameMessage,
                                       type: .alert,
                                       actions: [ButtonModel(name: Strings.Common.cancelButton,
                                                             style: .cancel,
                                                             action: nil)])
                self?.showAlertUntils(alert: alert)
            }
        }
        viewModel.passwordMessageValid.observe(on: self) { [weak self] passwordMessage in
            if let passwordMessage = passwordMessage {
                self?.showAlertDefault(message: passwordMessage)
            }
        }
    }
}
