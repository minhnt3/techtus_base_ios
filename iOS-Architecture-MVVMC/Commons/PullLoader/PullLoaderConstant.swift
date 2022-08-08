//
//  PullLoaderConstant.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/06/02.
//

import Foundation

enum PullLoaderConstants {

    enum PullLoaderText {
        static let releaseToRefreshDescription = "Release to refresh"
        static let loadingDescription = "Loading..."
        static let pullToRefreshDescription = "Pull to refresh"
        static let loadingMoreDescription: String = "Loading more"
        static let noMoreDataDescription: String  = "No more data"
    }

    enum PullLoaderKey {
        static let lastRefreshKey: String = "pulltorefresh.lastRefreshKey"
        static let expiredTimeIntervalKey: String = "pulltorefresh.expiredTimeIntervalKey"
    }
    enum PullLoaderImage {
        static let iconPullToRefreshArrow: String = "ic_pull_to_refresh_arrow"
    }
}
