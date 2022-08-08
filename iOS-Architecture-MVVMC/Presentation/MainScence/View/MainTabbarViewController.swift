//
//  MainTabbarViewController.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 11/07/2022.
//

import UIKit

class MainTabbarViewController: UITabBarController {

    private var parentCoordinator: BaseCoordinator?

    func bindDependencies(parentCoordinator: BaseCoordinator?) {
        self.parentCoordinator = parentCoordinator
        configureMainInterface()
    }

    func configureMainInterface() {
        let animalsNavigationController = UINavigationController()
        let animalsCoordinator = AnimalsCoordinator(navigationController: animalsNavigationController)
        animalsCoordinator.parentCoordinator = parentCoordinator
        animalsNavigationController.tabBarItem = UITabBarItem(title: "Animals",
                                                             image: UIImage.icHome,
                                                             selectedImage: nil)

        let profileNavigationController = UINavigationController()
        let profileCoordinator = ProfileCoordinator(navigationController: profileNavigationController)
        profileCoordinator.parentCoordinator = parentCoordinator
        profileNavigationController.tabBarItem = UITabBarItem(title: "Profile",
                                                              image: UIImage.icProfile,
                                                              selectedImage: nil)
        if #available(iOS 13, *) {
            let appearance = self.tabBar.standardAppearance.copy()
            appearance.backgroundImage = UIImage()
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            appearance.backgroundColor = .white
            self.tabBar.standardAppearance = appearance
        } else {
            self.tabBar.backgroundImage = UIImage()
            self.tabBar.shadowImage = UIImage()
        }
        self.tabBar.backgroundColor = UIColor.white
        let appearance = UITabBarItem.appearance()
        appearance.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30)], for: .normal)
        appearance.setTitleTextAttributes([.font: UIFont.systemFont(ofSize: 30)], for: .selected)
        self.viewControllers = [
            animalsNavigationController,
            profileNavigationController
        ]
        // Add the coordinator into parent's child
        parentCoordinator?.addChildCoordinator(animalsCoordinator)
        parentCoordinator?.addChildCoordinator(profileCoordinator)
        animalsCoordinator.start()
        profileCoordinator.start()
    }
}
