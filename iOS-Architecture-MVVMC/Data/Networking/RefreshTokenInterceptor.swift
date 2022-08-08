//
//  RefreshTokenInterceptor.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 08/06/2022.
//

import Foundation

protocol RefreshTokenInterceptor {
    var accessToken: String { get }
    var unauthorizedCode: Int { get }
    var expiration: Date? { get }
    /// The duration(in second) before expiration.
    var refreshInterval: Double? { get }

    func refresh(completion: @escaping (Result<String, Error>) -> Void)
}

// MARK: - APIRefreshTokenInterceptor
class APIRefreshTokenInterceptor: RefreshTokenInterceptor {
    var accessToken: String {
        return AppData.accessToken
    }

    var unauthorizedCode: Int {
        return 401
    }

    var expiration: Date? {
        return nil
    }

    /// The duration(in second) before expiration.
    var refreshInterval: Double? {
        return nil
    }

    private lazy var apiService: APIService = MoyaAPIService()

    func refresh(completion: @escaping (Result<String, Error>) -> Void) {
        _ = apiService.request(info: AppApi.refreshToken,
                               completion: { (result: Result<RefreshTokenData, Error>) in
            switch result {
            case .success(let refreshTokenData):
                AppData.accessToken = refreshTokenData.accessToken
                completion(.success(refreshTokenData.accessToken))
            case .failure:
                var error = ServiceError()
                error.serviceErrorType = .refreshToken
                completion(.failure(error))
            }
        })
    }
}
