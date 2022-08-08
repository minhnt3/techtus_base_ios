//
//  ProfileViewModel.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 24/05/2022.
//

import Foundation

protocol ProfileViewModelNavigation {
    func goToLogin()
}

protocol ProfileViewModelInput {
    func getProfile()
}

protocol ProfileViewModelOutput {
    var avatar: Observable<String> { get set }
    var name: Observable<String> { get set }
    var email: Observable<String> { get set }
    var phone: Observable<String> { get set }
    var city: Observable<String> { get set }
}

protocol ProfileViewModelType: ProfileViewModelInput, ProfileViewModelOutput {}

class ProfileViewModel: BaseViewModel, ProfileViewModelType {
    var avatar = Observable<String>()
    var name = Observable<String>()
    var email = Observable<String>()
    var phone = Observable<String>()
    var city = Observable<String>()

    var actions: ProfileViewModelNavigation?

    @Inject private var profileUseCase: ProfileUseCase
    @Inject private var networkReachabilityManager: NetworkReachabilityManager

    func getProfile() {
        if networkReachabilityManager.isReachable {
            usingAction(fromUseCase: profileUseCase.loadProfile(),
                        doSuccess: { [weak self] profile in
                self?.saveProfileIfNotExist(profile)
                self?.onLoadProfileSuccess(profile)
            })
        } else {
            usingAction(fromUseCase: profileUseCase.loadLocalProfile(),
                        doSuccess: { [weak self]  profile in
                if let profile = profile {
                    self?.onLoadProfileSuccess(profile)
                }
            })
        }
    }

    func doLogOut() {
        AppData.isLogged = false
        actions?.goToLogin()
    }

    private func saveProfileIfNotExist(_ profile: ProfileModel) {
        profileUseCase.isLocalProfileExisting(withID: profile.id ?? "",
                                              comletion: { [weak self] isExisting in
            if !isExisting {
                _ = self?.profileUseCase.createLocalProfile(profile)
            }
        })
    }

    private func onLoadProfileSuccess(_ profile: ProfileModel) {
        avatar.value = profile.avatar
        name.value = profile.name
        email.value = profile.email
        phone.value = profile.phone
        city.value = profile.city
    }
}
