//
//  DarkModeManager.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 29/06/2022.
//

import UIKit

final class DarkModeManager {

    private static var _shared: DarkModeManager?
    static var shared: DarkModeManager {
        if _shared == nil {
            _shared = DarkModeManager()
        }
        return _shared!
    }

    func configDarkMode() {
        self.changedDarkMode()
    }

    var theme: Theme {
        if #available(iOS 13.0, *) {
            if let themeType = AppData.themeType {
                return themeType == Theme.dark.rawValue ? Theme.dark : Theme.light
            }
            return UITraitCollection.current.userInterfaceStyle == .dark ? Theme.dark : Theme.light
        }
        return Theme.light
    }

    func changedDarkMode() {
        if let window = UIApplication.shared.delegate?.window {
            if #available(iOS 13.0, *) {
                window?.overrideUserInterfaceStyle = theme == Theme.dark ? .dark : .light
            }
        }
    }
}
