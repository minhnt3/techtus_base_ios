//
//  AppAppearance.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//
import Foundation
import UIKit

final class AppAppearance {
    /// change if need using only one language
    static var countryConstantApp: CountrysSignature?
}

extension UINavigationController {
    @objc override open var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

#if canImport(Firebase)
    import Firebase

    extension AppAppearance {
        static func configFirebase() {
            FirebaseApp.configure()
        }
    }
#endif
