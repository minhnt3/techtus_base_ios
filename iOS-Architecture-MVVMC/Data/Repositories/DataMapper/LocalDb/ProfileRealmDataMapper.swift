//
//  ProfileRealmDataMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 15/07/2022.
//

import Foundation

class ProfileRealmDataMapper: LocalDbMapper {
    typealias LocalObjectType = ProfileRealmLocalData
    typealias AppObjectType = ProfileModel

    func mapToAppObject(_ object: LocalObjectType) -> AppObjectType {
        return ProfileModel(id: object.id,
                            name: object.name,
                            avatar: object.avatar,
                            email: object.email,
                            phone: object.phone,
                            city: object.city)
    }

    func mapToAppObjects(_ objects: [LocalObjectType]) -> [AppObjectType] {
        return objects.map({ [unowned self] object in self.mapToAppObject(object) })
    }

    func mapToLocalObject(_ appObject: AppObjectType) -> LocalObjectType {
        let data = ProfileRealmLocalData()
        data.id = appObject.id ?? ""
        data.name = appObject.name ?? ""
        data.avatar = appObject.avatar ?? ""
        data.email = appObject.email ?? ""
        data.phone = appObject.phone ?? ""
        data.city = appObject.city ?? ""
        return data
    }

    func mapToLocalObjects(_ appObjects: [AppObjectType]) -> [LocalObjectType] {
        return appObjects.map({ [unowned self] object in self.mapToLocalObject(object) })
    }
}
