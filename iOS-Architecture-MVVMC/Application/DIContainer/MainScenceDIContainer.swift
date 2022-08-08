//
//  MainScenceDIContainer.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 23/05/2022.
//

import UIKit

final class MainSceneDIContainer: MainTabbarCoordinatorDependencies, AnimalsCoordinatorDependencies, ProfileCoordinatorDependencies {

    struct Dependencies {
        let apiService: APIService
        let languageManager: LanguageManager
        let themeManager: ThemeManager
        let localDbService: LocalDatabaseService?
        let networkReachabilityManager: NetworkReachabilityManager
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func initMainCoordinator(navigationController: UINavigationController) -> MainCoordinator {
        return MainCoordinator(navigationController: navigationController, dependencies: self)
    }

    func initMainTabbarViewController(parentCoordinator: BaseCoordinator?) -> MainTabbarViewController {
        let mainTabbarViewController = MainTabbarViewController()
        mainTabbarViewController.bindDependencies(parentCoordinator: parentCoordinator,
                                                  animalsDependencies: self,
                                                  profileDependencies: self)
        return mainTabbarViewController
    }

    func initProfileViewController(actions: ProfileViewModelNavigation) -> ProfileViewController {
        let profileViewModel = initProfileViewModel(actions: actions, profileUseCase: initProfileUseCase())
        let profileViewController = ProfileViewController()
        profileViewController.bindViewModel(to: profileViewModel)
        return profileViewController
    }

    func initAnimalsViewController() -> AnimalsViewController {
        let animalUseCase = initAnimalUseCase()
        let animalsViewController = AnimalsViewController()
        animalsViewController.bindViewModel(to: initAnimalViewModel(animalUseCase: animalUseCase))
        return animalsViewController
    }

    // MARK: - View Model
    func initProfileViewModel(actions: ProfileViewModelNavigation,
                              profileUseCase: ProfileUseCase) -> ProfileViewModel {
        return ProfileViewModel(actions: actions,
                                profileUseCase: profileUseCase,
                                networkReachabilityManager: dependencies.networkReachabilityManager)
    }

    func initAnimalViewModel(animalUseCase: AnimalUseCase) -> AnimalViewModel {
        return AnimalViewModel(animalUseCase: animalUseCase,
                               networkReachabilityManager: dependencies.networkReachabilityManager)
    }

    // MARK: - Use Cases
    func initLanguageUseCase() -> LanguageUseCase {
        return LanguageUseCaseImpl(repository: initRepository())
    }

    func initThemeUseCase() -> ThemeUseCase {
        return ThemeUseCaseImpl(repository: initRepository())
    }

    func initAnimalUseCase() -> AnimalUseCase {
        return AnimalUseCaseImp(repository: initRepository())
    }

    func initProfileUseCase() -> ProfileUseCase {
        return ProfileUseCaseImp(repository: initRepository())
    }

    // MARK: - Repositories
    func initRepository() -> Repository {
        return RepositoryImpl(apiService: dependencies.apiService,
                              languageManager: dependencies.languageManager,
                              themeManager: dependencies.themeManager,
                              localDbService: dependencies.localDbService)
    }
}
