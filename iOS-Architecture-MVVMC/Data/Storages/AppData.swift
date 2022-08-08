//
//  AppData.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/06/21.
//

import Foundation

struct AppData {
    @Storage(key: AppConstants.UserDefault.accessToken, defaultValue: "")
    static var accessToken: String

    @Storage(key: AppConstants.UserDefault.accessTokenExpiration, defaultValue: "")
    static var accessTokenExpiration: String

    @Storage(key: AppConstants.UserDefault.isLogged, defaultValue: false)
    static var isLogged: Bool

    @Storage(key: AppConstants.UserDefault.languageCode, defaultValue: "")
    static var languageCode: String

    @Storage(key: AppConstants.UserDefault.themeType, defaultValue: nil)
    static var themeType: Int?
}
