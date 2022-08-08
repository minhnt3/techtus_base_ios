//
//  AnimalCellViewModel.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_139 on 07/07/2022.
//

import Foundation

class AnimalCellViewModel: BaseCellViewModel {
    let name: String
    let weight: Int

    init(animal: AnimalModel) {
        name = animal.name
        weight = animal.weight
        super.init()
        nibName = "AnimalCell"
    }
}
