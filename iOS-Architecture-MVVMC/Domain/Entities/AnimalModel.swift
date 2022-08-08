//
//  AnimalModel.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_139 on 07/07/2022.
//

import Foundation

struct AnimalModel {
    let id: String
    let name: String
    let weight: Int

    init(id: String = UUID().uuidString) {
        self.id = id
        self.name = "Animal \(id)"
        self.weight = 10
    }

    init(id: String = UUID().uuidString, name: String, weight: Int) {
        self.id = id
        self.name = name
        self.weight = weight
    }
}
