//
//  LoginViewModel.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation

protocol LoginViewModelNavigation {
    func goBack()
    func goToMainScence()
}

protocol LoginViewModelInput {
    func doLogin(userName: String, password: String)
}

protocol LoginViewModelOutput {
    var usernameMessageValid: Observable<String> { get }
    var passwordMessageValid: Observable<String> { get }
}

protocol LoginViewModelType: LoginViewModelInput, LoginViewModelOutput {}

class LoginViewModel: BaseViewModel, LoginViewModelType {
    var usernameMessageValid: Observable<String> = Observable()
    var passwordMessageValid: Observable<String> = Observable()

    var actions: LoginViewModelNavigation?

    @Inject private var validUseCase: ValidUseCase
    @Inject private var loginUseCase: LoginUseCase

    func doLogin(userName: String, password: String) {
        if let userNameMessage = validUseCase.checkValidUsername(userName: userName) {
            usernameMessageValid.value = userNameMessage
            return
        }

        if let passwordMessage = validUseCase.checkValidPassword(password: password) {
            passwordMessageValid.value = passwordMessage
            return
        }

        usingAction(fromUseCase: loginUseCase.doLogin(userName: userName, password: password),
                    doSuccess: { [weak self] _ in
                        guard let self = self else { return }
                        self.state.value = .showLoading(false)
                        self.state.value = .showToast(Strings.LoginScreen.loginSuccessfulMessage)
                        // delay 0.5s for showing the toast message before navigation
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.actions?.goToMainScence()
                        }
        })
    }
}
