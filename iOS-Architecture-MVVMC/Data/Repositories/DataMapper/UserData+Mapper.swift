//
//  UserData+Mapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/31.
//

import Foundation

struct UserDataMapper: Mapper {
    typealias I = UserData
    typealias O = UserModel

    func map(_ input: UserData) -> UserModel {
        return UserModel(email: input.email ?? "",
                         name: input.name ?? "")
    }
}
