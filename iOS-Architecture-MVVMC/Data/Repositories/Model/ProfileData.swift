//
//  ProfileData.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 15/07/2022.
//

import Foundation

struct ProfileData: Decodable {
    let id: String?
    let name: String?
    let avatar: String?
    let email: String?
    let phone: String?
    let city: String?
}
