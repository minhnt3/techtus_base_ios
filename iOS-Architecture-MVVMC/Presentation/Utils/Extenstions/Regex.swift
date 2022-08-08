//
//  Regex.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import Foundation

struct Regex {
    static let email = "[A-Z0-9a-z._+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    static let password = "^[^0-9A-Z]{8,16}$"
    static let numberic = "[0-9]+"
}
