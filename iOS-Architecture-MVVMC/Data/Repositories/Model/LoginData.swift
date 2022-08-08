//
//  LoginData.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 22/06/2022.
//

import Foundation

struct LoginData: Decodable {
    let id: String
    let status: Int
    let accessToken: String
    let expiration: String
}
