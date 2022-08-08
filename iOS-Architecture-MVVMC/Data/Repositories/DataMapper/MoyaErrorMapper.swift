//
//  ErrorMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 09/06/2022.
//

import Foundation
import Moya
import Alamofire

struct MoyaErrorMapper: Mapper {
    typealias I = MoyaError
    typealias O = ServiceError
    /// returns ServiceError
    public func map(_ input: I) -> O {
        var message: String {
            switch input {
            case .imageMapping:
                return ServiceErrorType.noData.message
            case .jsonMapping:
                return ServiceErrorType.json.message
            case .stringMapping:
                return ServiceErrorType.jsonKeyMapping.message
            case .objectMapping:
                return ServiceErrorType.json.message
            case .encodableMapping:
                return ServiceErrorType.encodeData.message
            case let .statusCode(response):
                return ServiceErrorType.statusCode(response.statusCode).message
            case let .underlying(error, _):
                if !isInternetConnection(error: input) {
                    return ServiceErrorType.noInternet.message
                }
                return error.localizedDescription
            case .requestMapping:
                return ServiceErrorType.urlNotwork.message
            case .parameterEncoding:
                return ServiceErrorType.paramInputNotwork.message
            }
        }
        return ServiceError(message: message,
                            statusCode: input.response?.statusCode,
                            serviceErrorType: convertErrorType(error: input))
    }

    private func convertErrorType(error: MoyaError) -> ServiceErrorType {
        switch error {
        case .imageMapping,
                .jsonMapping,
                .stringMapping,
                .objectMapping,
                .requestMapping:
            return .jsonKeyMapping
        case let .statusCode(response):
            return .statusCode(response.statusCode)
        case .parameterEncoding:
            return .encodeData
        case .underlying:
            if !isInternetConnection(error: error) {
                return .noInternet
            }
            return .unknown
        default:
            return .unknown
        }
    }

    private func isInternetConnection(error: MoyaError) -> Bool {
        if let alamofireError = error.errorUserInfo["NSUnderlyingError"] as? Alamofire.AFError,
           let underlyingError = alamofireError.underlyingError as NSError?,
           [NSURLErrorNotConnectedToInternet, NSURLErrorDataNotAllowed, NSURLErrorNetworkConnectionLost].contains(underlyingError.code) {
            return false
        }
        return true
    }
}
