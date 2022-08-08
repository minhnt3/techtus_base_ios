//
//  ProfileDataMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 15/07/2022.
//

import Foundation

struct ProfileDataMapper: Mapper {
    typealias I = ProfileData
    typealias O = ProfileModel

    func map(_ input: ProfileData) -> ProfileModel {
        return ProfileModel(id: input.id,
                            name: input.name,
                            avatar: input.avatar,
                            email: input.email,
                            phone: input.phone,
                            city: input.city)
    }
}
