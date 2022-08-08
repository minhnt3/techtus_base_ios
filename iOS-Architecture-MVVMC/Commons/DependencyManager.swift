//
//  DependencyManager.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 20/07/2022.
//

import Foundation
import UIKit

class DependencyManager {
    init() {
        registerServices()
        registerRepository()
        registerCoordinators()
        registerViewControllers()
        registerViewModels()
        registerUseCases()
    }

    private func registerServices() {
        DependencyResolver.register {
            $0.singleton(APIService.self, MoyaAPIService())
            $0.singleton(NetworkReachabilityManager.self, NetworkReachabilityManagerImp())
            $0.singleton(LanguageManager.self, LanguageManager())
            $0.factory(Optional<LocalDatabaseService>.self) { RealmDatabaseService() }
            $0.singleton(ThemeManager.self, ThemeManager())
        }
    }

    private func registerRepository() {
        DependencyResolver.register {
            $0.factory(Repository.self, RepositoryImpl(apiService: DependencyResolver.resolve(),
                                                       languageManager: DependencyResolver.resolve(),
                                                       themeManager: DependencyResolver.resolve(),
                                                       localDbService: DependencyResolver.resolve()))
        }
    }

    private func registerCoordinators() {
        DependencyResolver.register {
            $0.factory(LoginCoordinator.self) { parameters in
                return LoginCoordinator(navigationController: parameters["navigationController"] as! UINavigationController)
            }
            $0.factory(MainCoordinator.self) { parameters in
                return MainCoordinator(navigationController: parameters["navigationController"] as! UINavigationController)
            }
        }
    }

    private func registerViewControllers() {
        DependencyResolver.register {
            $0.factory(LoginViewController())
            $0.factory(MainTabbarViewController())
            $0.factory(AnimalsViewController())
            $0.factory(ProfileViewController())
        }
    }

    private func registerViewModels() {
        DependencyResolver.register {
            $0.factory(LoginViewModel())
            $0.factory(AnimalViewModel())
            $0.factory(ProfileViewModel())
        }
    }

    private func registerUseCases() {
        DependencyResolver.register {
            $0.factory(ValidUseCase.self, ValidUseCaseImpl())
            $0.factory(LoginUseCase.self, LoginUseCaseImpl())
            $0.factory(AnimalUseCase.self, AnimalUseCaseImp(repository: DependencyResolver.resolve()))
            $0.factory(ProfileUseCase.self, ProfileUseCaseImp(repository: DependencyResolver.resolve()))
        }
    }
}
