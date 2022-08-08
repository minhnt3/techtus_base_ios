//
//  BaseServiceError.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 17/06/2022.
//

import Foundation

// MARK: Service error

protocol BaseErrorServiceConformType: Error, ErrorCommonConformType {
    var message: String? { get set }
    var id: Int? { get set }
    var statusCode: Int? { get set }
    var errorModel: ErrorModel? { get set }
}

struct ServiceError: BaseErrorServiceConformType {
    var type: AppErrorType? {
        return .service(self)
    }
    var message: String?
    var id: Int?
    var statusCode: Int?
    var errorModel: ErrorModel?
    var serviceErrorType: ServiceErrorType?
}

// MARK: Local error

protocol BaseErrorLocalConformType: Error, ErrorCommonConformType {
    var message: String? { get set }
}

struct LocalError: BaseErrorLocalConformType {
    var type: AppErrorType? {
        return .local(self)
    }

    var message: String?
}

// MARK: create some error here
