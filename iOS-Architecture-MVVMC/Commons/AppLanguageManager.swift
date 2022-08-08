//
//  AppLanguageManager.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 21/06/2022.
//

import Foundation

final class AppLanguageManager: LanguageCommon {
    static var shared = AppLanguageManager()
    var language: Observable<CountrysSignature> = Observable()

    func set(language: CountrysSignature) {
        AppData.languageCode = language.languageCode
        self.language.value = language
    }

    func sink(receivedLanguage received: @escaping (CountrysSignature?) -> Void) {
        language.observe(on: self) { language in
            received(language)
        }
    }
}

protocol LanguageCommon {
    var language: Observable<CountrysSignature> { get }
}
