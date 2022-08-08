//
//  ErrorServiceMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 17/06/2022.
//

import Foundation
import Moya

struct ErrorServiceMapper: Mapper {
    typealias I = Error
    typealias O = ServiceError

    public func map(_ input: I) -> O {
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        if let error = input as? MoyaError {
            if let response = error.response {
                do {
                    let body = try response.map(ErrorData.self,
                                                atKeyPath: nil,
                                                using: decoder,
                                                failsOnEmptyData: false)
                    return ServiceError(message: body.message,
                                        id: body.id,
                                        statusCode: response.statusCode,
                                        errorModel: ErrorDataMapper().map(body),
                                        serviceErrorType: .serverDefined)
                } catch let error {
                    guard let moyaError = error as? MoyaError else {
                        fatalError("Imposible case")
                    }
                    return MoyaErrorMapper().map(moyaError)
                }
            } else {
                return MoyaErrorMapper().map(error)
            }
        }
        return ServiceError(message: input.localizedDescription,
                            serviceErrorType: .unknown)
    }
}
