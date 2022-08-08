//
//  DarkModeUseCase.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 29/06/2022.
//

import Foundation

protocol ThemeUseCase {
    func changeTheme(theme: Theme)
}

class ThemeUseCaseImpl: ThemeUseCase {

    private var repository: Repository

    init(repository: Repository) {
        self.repository = repository
    }

    func changeTheme(theme: Theme) {
        self.repository.changeTheme(theme: theme)
    }
}
