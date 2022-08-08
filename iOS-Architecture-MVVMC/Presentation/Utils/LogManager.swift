//
//  LogManager.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/06/20.
//

import Foundation
import GoLog

final class Logs {
    static func configGoLog() {
        // This is data test
        let userDefaults = [GoLog.LocalUserDefaultsKey(key: "ud_key_1"), GoLog.LocalUserDefaultsKey(key: "ud_key_2")]
        let config = GoLog.Configuration(
            logToFile: true,
            debugAppInfoText: "iOS Architecture",
            addOnDebugMenu: [],
            userDefaultsKeys: userDefaults
        )
        GoLog.setup(with: config, debugMenuDelegate: nil)
    }

    static func showDebugMenu() {
        GoLog.showDebugMenu = true
    }
}

extension GoLog.Category {
    static let auth = GoLog.Category("AUTH")
}
