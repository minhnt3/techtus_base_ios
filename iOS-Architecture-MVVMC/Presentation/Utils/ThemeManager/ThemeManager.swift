//
//  ThemeManager.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 29/06/2022.
//

import UIKit

protocol ThemeManagerSubjectType {
    func notifyChangeTheme(theme: Theme)
}

public protocol ThemeObserver: AnyObject {
    func changeThemeManager(_ theme: Theme)
}

public protocol ThemeManagerType {
    func changeTheme(_ theme: Theme)
    func addThemeObserver(_ observer: ThemeObserver)
    func removeThemeObserver(_ observer: ThemeObserver)
}

class ThemeManager {

    private static var _share: ThemeManager?
    static var shared: ThemeManager {
        if _share == nil {
            _share = ThemeManager()
        }
        return _share!
    }

    init() {}

    private struct Observation {
        weak var observer: ThemeObserver?
    }

    private var observers: [Observation] = []

    func currentTheme() -> Theme {
        return DarkModeManager.shared.theme
    }

    func applyTheme(theme: Theme) {
        let style = theme.themeStyle
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.titleTextAttributes = [.foregroundColor: style.titleColor]
            appearance.backgroundColor = style.primaryColor
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().barTintColor = style.primaryColor
            UINavigationBar.appearance().tintColor = style.primaryColor
            UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: style.titleColor]
        }
    }
}

extension ThemeManager: ThemeManagerSubjectType, ThemeManagerType {
    func addThemeObserver(_ observer: ThemeObserver) {
        observers = observers.filter({($0.observer != nil && $0.observer !== observer)})
        observers.append(.init(observer: observer))
    }

    func removeThemeObserver(_ observer: ThemeObserver) {
        observers = observers.filter({($0.observer != nil && $0.observer !== observer)})
    }

    func changeTheme(_ theme: Theme) {
        notifyChangeTheme(theme: theme)
        applyTheme(theme: theme)
        DarkModeManager.shared.changedDarkMode()
    }

    func notifyChangeTheme(theme: Theme) {
        observers.forEach { $0.observer?.changeThemeManager(theme) }
    }
}
