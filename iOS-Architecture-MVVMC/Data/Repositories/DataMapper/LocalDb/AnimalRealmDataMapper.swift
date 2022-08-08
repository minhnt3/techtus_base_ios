//
//  AnimalRealmDataMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_139 on 07/07/2022.
//

import Foundation

class AnimalRealmDataMapper: LocalDbMapper {
    typealias LocalObjectType = AnimalRealmLocalData
    typealias AppObjectType = AnimalModel

    func mapToAppObject(_ object: AnimalRealmLocalData) -> AnimalModel {
        return AnimalModel(id: object.id, name: object.name, weight: object.weight)
    }

    func mapToAppObjects(_ objects: [AnimalRealmLocalData]) -> [AnimalModel] {
        return objects.map(mapToAppObject(_:))
    }

    func mapToLocalObject(_ appObject: AnimalModel) -> AnimalRealmLocalData {
        let data = AnimalRealmLocalData()
        data.id = appObject.id
        data.name = appObject.name
        data.weight = appObject.weight
        return data
    }

    func mapToLocalObjects(_ appObjects: [AnimalModel]) -> [AnimalRealmLocalData] {
        return appObjects.map(mapToLocalObject(_:))
    }
}
