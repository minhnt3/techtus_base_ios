//
//  LaguageUseCase.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/06/22.
//

import Foundation

protocol LanguageUseCase {
    func changeLanguage(languageCode: CountrysSignature)
}

class LanguageUseCaseImpl: LanguageUseCase {
    private let repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func changeLanguage(languageCode: CountrysSignature) {
        repository.changeLanguage(languageCode: languageCode)
    }
}
