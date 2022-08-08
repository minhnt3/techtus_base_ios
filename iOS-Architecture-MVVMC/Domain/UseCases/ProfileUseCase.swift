//
//  ProfileUseCase.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 15/07/2022.
//

import Foundation

protocol ProfileUseCase {
    func loadProfile() -> Observable<Result<ProfileModel, ServiceError>>
    func loadLocalProfile() -> Observable<Result<ProfileModel?, LocalError>>
    func createLocalProfile(_ profile: ProfileModel) -> Observable<Result<Void, LocalError>>
    func isLocalProfileExisting(withID id: String, comletion: @escaping (Bool) -> Void)
}

class ProfileUseCaseImp: ProfileUseCase {
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func loadProfile() -> Observable<Result<ProfileModel, ServiceError>> {
        let observable = Observable<Result<ProfileModel, ServiceError>>()
        _ = repository.loadProfile(completion: { result in
            observable.value = result
        })
        return observable
    }

    func loadLocalProfile() -> Observable<Result<ProfileModel?, LocalError>> {
        let observable = Observable<Result<ProfileModel?, LocalError>>()
        _ = repository.loadLocalProfile(completion: { result in
            observable.value = result
        })
        return observable
    }

    func createLocalProfile(_ profile: ProfileModel) -> Observable<Result<Void, LocalError>> {
        let observable = Observable<Result<Void, LocalError>>()
        _ = repository.addLocalProfile(profile, completion: { result in
            observable.value = result
        })
        return observable
    }

    func isLocalProfileExisting(withID id: String, comletion: @escaping (Bool) -> Void) {
        repository.isLocalProfileExisting(withID: id, completion: comletion)
    }
}
