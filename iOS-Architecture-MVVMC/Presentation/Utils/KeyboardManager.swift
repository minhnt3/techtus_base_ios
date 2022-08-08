//
//  KeyboardManager.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 09/06/2022.
//

import Foundation
import IQKeyboardManagerSwift

class KeyboardManager {
    static func config() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
}
