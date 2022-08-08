//
//  LoginRepository.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation

class RepositoryImpl: Repository {
    let apiService: APIService
    let languageManager: LanguageManager
    let themeManager: ThemeManager
    let localDbService: LocalDatabaseService?

    private let animalRealmDataMapper = AnimalRealmDataMapper()
    private let profileRealmDataMapper = ProfileRealmDataMapper()

    init(apiService: APIService,
         languageManager: LanguageManager,
         themeManager: ThemeManager,
         localDbService: LocalDatabaseService?) {
        self.apiService = apiService
        self.languageManager = languageManager
        self.themeManager = themeManager
        self.localDbService = localDbService
    }

    func doLogin(userName: String, password: String, completion: @escaping LoginResult) -> Cancellable? {
        apiService.request(info: AppApi.login(username: userName, password: password),
                           completion: { (result: Result<LoginData, Error>) in
                               switch result {
                               case let .success(data):
                                   let loginModel = LoginDataMapper().map(data)
                                   completion(.success(loginModel))
                               case let .failure(error):
                                   let serviceError = error as? ServiceError ?? ServiceError()
                                   completion(.failure(serviceError))
                               }
                           })
    }

    func changeLanguage(languageCode: CountrysSignature) {
        AppData.languageCode = languageCode.languageCode
        languageManager.changeLanguage(languageCode.languageCode)
    }

    func changeTheme(theme: Theme) {
        if theme.rawValue != AppData.themeType {
            AppData.themeType = theme.rawValue
            themeManager.changeTheme(theme)
        }
    }

    // MARK: - Animal
    func isLocalAnimalExisting(withID id: String, completion: @escaping (Bool) -> Void) {
        localDbService?.isExisting(withMapper: animalRealmDataMapper,
                                   primaryKey: id,
                                   completion: { isExisting in
            completion(isExisting)
        })
    }

    func loadLocalAnimals(completion: @escaping LoadLocalAnimalsResult) {
        if case .failure(let error) = checkLocalDbService() {
            completion(.failure(error))
            return
        }

        localDbService?.find(withMapper: animalRealmDataMapper, completion: { animals in
            completion(.success(animals))
        })
    }

    func addLocalAnimal(_ animal: AnimalModel, completion: @escaping AddLocalAnimalResult) {
        if case .failure(let error) = checkLocalDbService() {
            completion(.failure(error))
            return
        }

        localDbService?.create(animal, withMapper: animalRealmDataMapper, completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func addLocalAnimals(_ animals: [AnimalModel], completion: @escaping AddLocalAnimalResult) {
        if case .failure(let error) = checkLocalDbService() {
            completion(.failure(error))
            return
        }

        localDbService?.create(animals, withMapper: animalRealmDataMapper, completion: { result in
            switch result {
            case .success:
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }

    func loadAnimals(completion: @escaping LoadAnimalsResult) -> Cancellable? {
        apiService.request(info: AppApi.animals, completion: { (result: Result<[AnimalData], Error>) in
            switch result {
            case .failure(let failure):
                let serviceError = failure as? ServiceError ?? ServiceError()
                completion(.failure(serviceError))
            case .success(let data):
                let animals = AnimalDataMapper().map(data)
                completion(.success(animals))
            }
        })
    }

    // MARK: - Profile
    func loadProfile(completion: @escaping (Result<ProfileModel, ServiceError>) -> Void) -> Cancellable? {
        apiService.request(info: AppApi.profile, completion: { (result: Result<[ProfileData], Error>) in
            switch result {
            case .failure(let failure):
                let serviceError = failure as? ServiceError ?? ServiceError()
                completion(.failure(serviceError))
            case .success(let data):
                let profile = ProfileDataMapper().map(data.first!)
                completion(.success(profile))
            }
        })
    }

    func loadLocalProfile(completion: @escaping (Result<ProfileModel?, LocalError>) -> Void) {
        if case .failure(let error) = checkLocalDbService() {
            completion(.failure(error))
            return
        }

        localDbService?.find(withMapper: profileRealmDataMapper, completion: { profiles in
            completion(.success(profiles?.first))
        })
    }

    func addLocalProfile(_ profile: ProfileModel, completion: @escaping (Result<Void, LocalError>) -> Void) {
        if case .failure(let error) = checkLocalDbService() {
            completion(.failure(error))
            return
        }

        localDbService?.create(profile, withMapper: profileRealmDataMapper, completion: completion)
    }

    func isLocalProfileExisting(withID id: String, completion: @escaping (Bool) -> Void) {
        localDbService?.isExisting(withMapper: profileRealmDataMapper,
                                   primaryKey: id,
                                   completion: { isExisting in
            completion(isExisting)
        })
    }

    // MARK: - Private
    private func checkLocalDbService() -> Result<LocalDatabaseService, LocalError> {
        guard let localDbService = localDbService else {
            let error = LocalError(message: "Unable to open local database service")
            return .failure(error)
        }
        return .success(localDbService)
    }
}
