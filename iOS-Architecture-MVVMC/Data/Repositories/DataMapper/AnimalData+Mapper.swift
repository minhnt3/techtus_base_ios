//
//  AnimalData+Mapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 12/07/2022.
//

import Foundation

struct AnimalDataMapper: Mapper, ListMapperType {
    typealias I = AnimalData
    typealias O = AnimalModel

    func map(_ input: AnimalData) -> AnimalModel {
        return AnimalModel(id: input.id, name: input.name, weight: input.weight)
    }

    func map(_ input: [AnimalData]) -> [AnimalModel] {
        input.map({ self.map($0) })
    }
}
