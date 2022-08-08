//
//  LoginRepositoryType.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation

typealias LoginResult = (Result<LoginModel, ServiceError>) -> Void
// animals
typealias LoadAnimalsResult = (Result<[AnimalModel], ServiceError>) -> Void
typealias LoadLocalAnimalsResult = (Result<[AnimalModel]?, LocalError>) -> Void
typealias AddLocalAnimalResult = (Result<Void, LocalError>) -> Void

protocol Repository {
    func doLogin(userName: String, password: String, completion: @escaping LoginResult) -> Cancellable?
    func changeLanguage(languageCode: CountrysSignature)
    func changeTheme(theme: Theme)
    // animals
    func isLocalAnimalExisting(withID id: String, completion: @escaping (Bool) -> Void)
    func loadLocalAnimals(completion: @escaping LoadLocalAnimalsResult)
    func addLocalAnimal(_ animal: AnimalModel, completion: @escaping AddLocalAnimalResult)
    func addLocalAnimals(_ animals: [AnimalModel], completion: @escaping AddLocalAnimalResult)
    func loadAnimals(completion: @escaping LoadAnimalsResult) -> Cancellable?
    // profile
    func loadProfile(completion: @escaping (Result<ProfileModel, ServiceError>) -> Void) -> Cancellable?
    func loadLocalProfile(completion: @escaping (Result<ProfileModel?, LocalError>) -> Void)
    func addLocalProfile(_ profile: ProfileModel, completion: @escaping (Result<Void, LocalError>) -> Void)
    func isLocalProfileExisting(withID id: String, completion: @escaping (Bool) -> Void)
}
