//
//  Localize.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation

class Localize: NSObject {
    class func availableLanguages(_ excludeBase: Bool = false) -> [String] {
        var availableLanguages = Bundle.main.localizations
        // If excludeBase = true, don't include "Base" in available languages
        if let indexOfBase = availableLanguages.firstIndex(of: AppConstants.Localizes.kBaseBundle),
           excludeBase == true {
            availableLanguages.remove(at: indexOfBase)
        }
        return availableLanguages
    }

    class func defaultLanguage() -> String {
        // because using japan language for default
        var defaultLanguage: String = AppConstants.Localizes.kDefaultLanguage
        guard let preferredLanguage = Locale.preferredLanguages.first?.lowercased() else {
            return AppConstants.Localizes.kDefaultLanguage
        }
        let availableLanguages: [String] = self.availableLanguages()
        availableLanguages.forEach { language in
            if preferredLanguage.hasPrefix(language) {
                defaultLanguage = language
            }
        }
        return defaultLanguage
    }

    class func setLanguage(country: CountrysSignature) -> String {
        return country.rawValue
    }

    class func currentLanguage() -> String {
        return defaultLanguage()
    }
}
