//
//  ErrorDataMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 09/06/2022.
//

import Foundation

struct ErrorDataMapper: Mapper {
    typealias I = ErrorData
    typealias O = ErrorModel
    /// returns ServiceErrorType
    public func map(_ input: I) -> O {
        return ErrorModel(id: input.id,
                         errorCode: input.errorCode ?? "",
                         title: input.title ?? "",
                         message: input.message ?? "",
                         description: input.description ?? "")
    }
}
