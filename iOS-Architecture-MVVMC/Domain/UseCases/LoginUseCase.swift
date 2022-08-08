//
//  LoginUseCase.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation

protocol LoginUseCase {
    func doLogin(userName: String, password: String) -> Observable<Result<LoginModel, ServiceError>>
}

final class LoginUseCaseImpl: LoginUseCase {
    @Inject private var loginRepository: Repository

    func doLogin(userName: String,
                 password: String) -> Observable<Result<LoginModel, ServiceError>> {
        let resultObserver: Observable<Result<LoginModel, ServiceError>> = Observable()
        _ = loginRepository.doLogin(userName: userName, password: password) { result in
            resultObserver.value = result
            result.doSucces { data in
                AppData.isLogged = true
                AppData.accessToken = data.accessToken
                AppData.accessTokenExpiration = data.expiration
            }
        }
        return resultObserver
    }
}
