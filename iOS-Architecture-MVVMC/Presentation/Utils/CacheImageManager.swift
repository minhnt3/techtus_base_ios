//
//  CacheImageManager.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 31/05/2022.
//

import Foundation
import Kingfisher

class CacheImageManager {
    /**
     Configure image cache for the application.
        totalCostLimit: Limit the amount of cache on the cache(MB).
        countLimit: Limit how many images can be stored in the cache.
        sizeLimit: Limit the amount of cache on the drive(MB).
        memoryExpiration: Memory cache expiration time.
        diskExpiration: Memory disk expiration time.
     */
    static func configCache(totalCostLimit: Int = AppConstants.ImageCache.totalCostLimit,
                            countLimit: Int = AppConstants.ImageCache.countLimit,
                            sizeLimit: Int = AppConstants.ImageCache.sizeLimit,
                            memoryExpiration: ImageCacheExpiration = AppConstants.ImageCache.memoryExpiration,
                            diskExpiration: ImageCacheExpiration = AppConstants.ImageCache.diskExpiration) {
        let cache = ImageCache.default
        cache.memoryStorage.config.totalCostLimit = totalCostLimit * 1024 * 1024
        cache.memoryStorage.config.countLimit = countLimit
        cache.diskStorage.config.sizeLimit = UInt(sizeLimit * 1024 * 1024)
        // Manage memory expired images
        switch memoryExpiration {
        case .never:
            cache.memoryStorage.config.expiration = .never
        case .seconds(let seconds):
            cache.memoryStorage.config.expiration = .seconds(seconds)
        case .days(let days):
            cache.memoryStorage.config.expiration = .days(days)
        case .date(let date):
            cache.memoryStorage.config.expiration = .date(date)
        case .expired:
            cache.memoryStorage.config.expiration = .expired
        }
        switch diskExpiration {
        case .never:
            cache.diskStorage.config.expiration = .never
        case .seconds(let second):
            cache.diskStorage.config.expiration = .seconds(second)
        case .days(let days):
            cache.diskStorage.config.expiration = .days(days)
        case .date(let date):
            cache.diskStorage.config.expiration = .date(date)
        case .expired:
            cache.diskStorage.config.expiration = .expired
        }
    }
    static func checkSizeCache() {
        ImageCache.default.calculateDiskStorageSize { result in
            switch result {
            case .success(let size):
                print("disk cache size(MB) = \(Double(size) / 1024 / 1024)")
            case .failure(let error):
                print(error)
            }
        }
    }
    static func clearAllCache() {
        ImageCache.default.clearMemoryCache()
        ImageCache.default.clearDiskCache { print("Finished clear disk cache") }
    }
    static func clearOnlyExpiredMemoryCache() {
        ImageCache.default.cleanExpiredMemoryCache()
        ImageCache.default.cleanExpiredDiskCache { print("Finished clean expired disk cache") }
    }
}

enum ImageCacheExpiration {
    case never
    /// The item expires after a time duration of given seconds from now.
    case seconds(second: Double)
    /// The item expires after a time duration of given days from now.
    case days(days: Int)
    /// The item expires after a given date.
    case date(date: Date)
    /// Indicates the item is already expired. Use this to skip cache.
    case expired
}
