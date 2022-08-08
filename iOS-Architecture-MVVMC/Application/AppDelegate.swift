//
//  AppDelegate.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/04/20.
//

import UIKit
import GoLog

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let dependencyManager = DependencyManager()
    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        #if canImport(Firebase)
        AppAppearance.configFirebase()
        #endif
        CacheImageManager.configCache()
        KeyboardManager.config()
        Logs.configGoLog()
        window = UIWindow(frame: UIScreen.main.bounds)
        let navigationController = UINavigationController()
        window?.rootViewController = navigationController
        appCoordinator = AppCoordinator(navigationController: navigationController)
        appCoordinator?.start()

        window?.makeKeyAndVisible()
        Logs.showDebugMenu()
        DarkModeManager.shared.configDarkMode()
        ThemeManager.shared.applyTheme(theme: DarkModeManager.shared.theme)
        return true
    }
}
