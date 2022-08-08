//
//  AnimalUseCase.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_139 on 07/07/2022.
//

import Foundation

protocol AnimalUseCase {
    func loadAnimals() -> Observable<Result<[AnimalModel], ServiceError>>
    func loadLocalAnimals() -> Observable<Result<[AnimalModel]?, LocalError>>
    func createLocalAnimal(_ animal: AnimalModel) -> Observable<Result<Void, LocalError>>
    func createLocalAnimals(_ animals: [AnimalModel]) -> Observable<Result<Void, LocalError>>
    func isLocalAnimalExisting(withID id: String, comletion: @escaping (Bool) -> Void)
}

class AnimalUseCaseImp: AnimalUseCase {
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func loadAnimals() -> Observable<Result<[AnimalModel], ServiceError>> {
        let observable = Observable<Result<[AnimalModel], ServiceError>>()
        _ = repository.loadAnimals(completion: { result in
            observable.value = result
        })
        return observable
    }

    func loadLocalAnimals() -> Observable<Result<[AnimalModel]?, LocalError>> {
        let observable = Observable<Result<[AnimalModel]?, LocalError>>()
        repository.loadLocalAnimals(completion: { result in
            observable.value = result
        })
        return observable
    }

    func createLocalAnimal(_ animal: AnimalModel) -> Observable<Result<Void, LocalError>> {
        let observable = Observable<Result<Void, LocalError>>()
        repository.addLocalAnimal(animal, completion: { result in
            observable.value = result
        })
        return observable
    }

    func createLocalAnimals(_ animals: [AnimalModel]) -> Observable<Result<Void, LocalError>> {
        let observable = Observable<Result<Void, LocalError>>()
        repository.addLocalAnimals(animals, completion: { result in
            observable.value = result
        })
        return observable
    }

    func isLocalAnimalExisting(withID id: String, comletion: @escaping (Bool) -> Void) {
        repository.isLocalAnimalExisting(withID: id, completion: comletion)
    }
}
