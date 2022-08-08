//
//  ValidUseCase.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 06/06/2022.
//

import Foundation

protocol ValidUseCase {
    func checkValidUsername(userName: String) -> String?
    func checkValidPassword(password: String) -> String?
}
final class ValidUseCaseImpl: ValidUseCase {
    func checkValidUsername(userName: String) -> String? {
        return (userName.isEmpty || userName.trimSpaceAndNewLine.isEmpty) ? Strings.LoginScreen.enterUserNameMessage : nil
    }
    func checkValidPassword(password: String) -> String? {
        return (password.isEmpty || password.trimSpaceAndNewLine.isEmpty) ? Strings.LoginScreen.enterPasswordMessage : nil
    }
}
