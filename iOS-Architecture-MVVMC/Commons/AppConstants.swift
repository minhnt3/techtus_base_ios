//
//  AppConstants.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/23.
//

import Foundation

enum AppConstants {
    enum Localizes {
        /// Default language  load app
        static let kDefaultLanguage = CountrysSignature.japan.rawValue
        /// Base bundle as fallback.
        static let kBaseBundle = "Base"
    }
    enum ImageCache {
        /// Default limit the amount of cache on the cache(MB)
        static let totalCostLimit = 2048
        /// Default limit how many images can be stored in the cache
        static let countLimit = 100
        /// Default limit the amount of cache on the drive(MB)
        static let sizeLimit = 2048
        /// Default memory cache expiration time
        static let memoryExpiration: ImageCacheExpiration = .seconds(second: 3600)
        /// Default memory disk expiration time
        static let diskExpiration: ImageCacheExpiration = .never
    }

    enum UserDefault {
        static let accessToken = "accessToken"
        static let accessTokenExpiration = "accessTokenExpiration"
        static let isLogged = "isLogged"
        static let languageCode = "languageCode"
        static let themeType = "themeType"
    }
}
