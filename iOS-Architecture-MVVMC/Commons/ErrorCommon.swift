//
//  ErrorCommon.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 08/06/2022.
//

import Foundation

enum AppErrorType {
    case service(ServiceError)
    case local(LocalError)
    // additional some type
    case unowned
}

protocol ErrorCommonConformType {
    var type: AppErrorType? { get }
}

struct ErrorCommon {
    var type: AppErrorType
    var message: String {
        switch type {
        case let .service(serviceError):
            return serviceError.message ?? ""
        case let .local(localError):
            return localError.message ?? ""
        case .unowned:
            return ""
        }
    }

    init(error: Error?) {
        if let error = error as? ErrorCommonConformType {
            type = error.type ?? .unowned
        } else {
            type = .unowned
        }
    }
}
