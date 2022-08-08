//
//  AnimalsViewModel.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_139 on 07/07/2022.
//

import Foundation

class AnimalViewModel: BaseViewModel {
    let animalsObservable = Observable<[AnimalCellViewModel]>()

    @Inject private var animalUseCase: AnimalUseCase
    @Inject private var networkReachabilityManager: NetworkReachabilityManager

    func fetchAnimals() {
        if networkReachabilityManager.isReachable {
            usingAction(fromUseCase: animalUseCase.loadAnimals(),
                        doSuccess: { [weak self] animals in
                self?.saveAnimalsIfNotExist(animals)
                self?.onLoadAnimalsSuccess(animals)
            })
        } else {
            usingAction(fromUseCase: animalUseCase.loadLocalAnimals(),
                        doSuccess: { [weak self]  animals in
                self?.onLoadAnimalsSuccess(animals ?? [])
            })
        }
    }

    private func saveAnimalsIfNotExist(_ animals: [AnimalModel]) {
        for animal in animals {
            animalUseCase.isLocalAnimalExisting(withID: animal.id,
                                                comletion: { [weak self] isExisting in
                if !isExisting {
                    _ = self?.animalUseCase.createLocalAnimal(animal)
                }
            })
        }
    }

    private func onLoadAnimalsSuccess(_ animals: [AnimalModel]) {
        animalsObservable.value = animals.map({ AnimalCellViewModel(animal: $0) })
    }
}
