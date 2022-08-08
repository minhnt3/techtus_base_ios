//
//  AppDIContainer.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation

final class AppDIContainer {
    // MARK: init services
    lazy var apiService: APIService = {
        return MoyaAPIService()
    }()

    lazy var languageManager: LanguageManager = {
        return LanguageManager()
    }()

    lazy var localDbService: LocalDatabaseService? = {
        return RealmDatabaseService()
    }()

    lazy var networkReachabilityManager: NetworkReachabilityManager = {
        return NetworkReachabilityManagerImp()
    }()

    func initLoginSceneDIContainer() -> LoginSceneDIContainer {
        let dependencies = LoginSceneDIContainer.Dependencies(apiService: apiService, languageManager: languageManager, themeManager: ThemeManager.shared, localDbService: localDbService)
        return LoginSceneDIContainer(dependencies: dependencies)
    }

    func initMainScenceDIContainer() -> MainSceneDIContainer {
        let dependencies = MainSceneDIContainer.Dependencies(apiService: apiService,
                                                             languageManager: languageManager,
                                                             themeManager: ThemeManager.shared,
                                                             localDbService: localDbService,
                                                             networkReachabilityManager: networkReachabilityManager)
        return MainSceneDIContainer(dependencies: dependencies)
    }
}
