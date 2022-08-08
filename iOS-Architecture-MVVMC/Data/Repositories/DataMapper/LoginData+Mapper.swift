//
//  LoginData+Mapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 23/06/2022.
//

import Foundation

struct LoginDataMapper: Mapper {
    typealias I = LoginData
    typealias O = LoginModel

    func map(_ input: LoginData) -> LoginModel {
        return LoginModel(accessToken: input.accessToken,
                          expiration: input.expiration)
    }
}
