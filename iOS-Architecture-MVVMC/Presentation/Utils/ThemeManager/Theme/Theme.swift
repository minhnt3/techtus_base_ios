//
//  Theme.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 29/06/2022.
//

import UIKit

protocol ThemeStyle {
    var primaryColor: UIColor { get }
    var secondaryColor: UIColor { get }
    var titleColor: UIColor { get }
}

public enum Theme: Int {
    case light = 0, dark

    var themeStyle: ThemeStyle {
        switch self {
        case .light:
            return LightTheme()
        case .dark:
            return DarkTheme()
        }
    }
}
