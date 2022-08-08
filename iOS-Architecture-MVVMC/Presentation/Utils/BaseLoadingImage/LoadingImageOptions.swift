//
//  LoadingImageOptions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 31/05/2022.
//

import Foundation
import Kingfisher

typealias LoadingImageModifierBlock = (URLRequest) -> URLRequest?
struct LoadingImageOptions {
    // Callback request to download image when error
    var retryStrategy: ImageRetryStrategy? = ImageRetryStrategy(maxRetryCount: 2, retryTime: 3)
    // Corner of an Image
    var roundCornerImage: RoundCornerLoadingImage?
    // Show image effect
    var imageTransition: LoadingImageTransition = .none
    // Will ignore the cache and try to start a download task for the image source.
    var forceRefresh: Bool = false
    // Priority of image download task. The value for it should be between 0.0~1.0
    var priority: Float = URLSessionTask.defaultPriority
    // Save only cache
    var onlyFromCache: Bool = false
    // The associated value will be used as the scale factor when converting retrieved data to an image. (2x, 3x)
    var scaleFactorValue: CGFloat = 1
    //  Keep the existing image of image view while setting another image to it.
    //  The placeholder image parameter of image view extension method will be ignored and the current image will be kept while loading or downloading the new image
    var keepCurrentImageWhileLoading: Bool = false
    // The original image will be only cached to disk storage.
    var cacheOriginalImage: Bool = false
    // The expiration setting for memory cache.
    var cacheExpiration: LoadingImageStorageExpiration = .days(3)
    // The expiration setting for disk cache
    var diskExpiration: LoadingImageStorageExpiration = .days(3)
    // This is the last chance you can modify the image download request. You can modify the request for some
    // customizing purpose, such as adding auth token to the header, do basic HTTP auth or something like url mapping.
    // Ex: Set auth with token
    var requestModifier: LoadingImageModifierBlock?
    func loadOptions() -> KingfisherOptionsInfo? {
        var options: KingfisherOptionsInfo? = KingfisherOptionsInfo()
        if let retryStrategy = createRetryStrategy() {
            options?.append(.retryStrategy(retryStrategy))
        }
        if let roundCornerImage = createRoundCornerImage() {
            options?.append(.processor(roundCornerImage))
        }
        if forceRefresh {
            options?.append(.forceRefresh)
        }
        if onlyFromCache {
            options?.append(.onlyFromCache)
        }
        if keepCurrentImageWhileLoading {
            options?.append(.keepCurrentImageWhileLoading)
        }
        if cacheOriginalImage {
            options?.append(.cacheOriginalImage)
        }
        if let requestModifier = requestModifier {
            let modifier = AnyModifier(modify: requestModifier)
            options?.append(.requestModifier(modifier))
        }
        options?.append(.memoryCacheExpiration(createMemoryCacheExpiration()))
        options?.append(.memoryCacheExpiration(createMemoryDiskExpiration()))
        options?.append(.transition(createLoadingImageTransition()))
        options?.append(.downloadPriority(priority))
        options?.append(.scaleFactor(scaleFactorValue))
        return options
    }
    func createRetryStrategy() -> DelayRetryStrategy? {
        if let retryStrategy = retryStrategy {
            let maxRetryCount = retryStrategy.maxRetryCount
            let retryTime =  retryStrategy.retryTime
            return DelayRetryStrategy(maxRetryCount: maxRetryCount, retryInterval: .seconds(retryTime))
        }
        return nil
    }
    func createRoundCornerImage() -> RoundCornerImageProcessor? {
        if let roundCornerImage = roundCornerImage {
            let cornerRadius = roundCornerImage.cornerRadius
            let targetSize = roundCornerImage.targetSize
            let roundingCorners = roundCornerImage.roundingCorners
            let backgroundColor = roundCornerImage.backgroundColor
            var rectCorner: RectCorner = .all
            switch roundingCorners {
            case .topLeft:
                rectCorner = .topLeft
            case .topRight:
                rectCorner = .topRight
            case .bottomLeft:
                rectCorner = .bottomLeft
            case .bottomRight:
                rectCorner = .bottomRight
            case .all:
                rectCorner = .all
            }
            return RoundCornerImageProcessor(cornerRadius: cornerRadius, targetSize: targetSize, roundingCorners: rectCorner, backgroundColor: backgroundColor)
        }
        return nil
    }
    func createLoadingImageTransition() -> ImageTransition {
        switch imageTransition {
        case .none:
            return ImageTransition.none
        case .fade(let timeInterval):
            return .fade(timeInterval)
        case .flipFromLeft(let timeInterval):
            return .flipFromLeft(timeInterval)
        case .flipFromRight(let timeInterval):
            return .flipFromRight(timeInterval)
        case .flipFromTop(let timeInterval):
            return .flipFromTop(timeInterval)
        case .flipFromBottom(let timeInterval):
            return .flipFromBottom(timeInterval)
        }
    }
    func createMemoryCacheExpiration() -> StorageExpiration {
        switch cacheExpiration {
        case .never:
            return .never
        case .seconds(let timeInterval):
            return .seconds(timeInterval)
        case .days(let int):
            return .days(int)
        case .date(let date):
            return .date(date)
        case .expired:
            return .expired
        }
    }
    func createMemoryDiskExpiration() -> StorageExpiration {
        switch diskExpiration {
        case .never:
            return .never
        case .seconds(let timeInterval):
            return .seconds(timeInterval)
        case .days(let int):
            return .days(int)
        case .date(let date):
            return .date(date)
        case .expired:
            return .expired
        }
    }
}

// Reload image when image load error
struct ImageRetryStrategy {
    // Maximum image load
    var maxRetryCount: Int
    // Declare seconds
    var retryTime: Double
}

struct RoundCornerLoadingImage {
    var cornerRadius: CGFloat
    // Target size of output image should be
    var targetSize: CGSize?
    var roundingCorners: RectCornerLoadingImage = .all
    var backgroundColor: UIColor?
}

indirect enum RectCornerLoadingImage {
    case topLeft, topRight, bottomLeft, bottomRight, all
}

enum LoadingImageTransition {
    case none
    // Fade in the loaded image in a given duration.
    case fade(TimeInterval)
    // Flip from left transition.
    case flipFromLeft(TimeInterval)
    // Flip from right transition.
    case flipFromRight(TimeInterval)
    // Flip from top transition.
    case flipFromTop(TimeInterval)
    // Flip from bottom transition.
    case flipFromBottom(TimeInterval)
}

enum LoadingImageStorageExpiration {
    case never
    // The item expires after a time duration of given seconds from now.
    case seconds(TimeInterval)
    // The item expires after a time duration of given days from now.
    case days(Int)
    // The item expires after a given date.
    case date(Date)
    // Indicates the item is already expired. Use this to skip cache.
    case expired
}
