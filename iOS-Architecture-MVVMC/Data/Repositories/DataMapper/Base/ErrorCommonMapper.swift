//
//  ErrorMaper.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 09/06/2022.
//

import Foundation

struct ErrorCommonMapper: Mapper {
    typealias I = Error
    typealias O = ErrorCommon
    /// returns  Error Common
    public func map(_ input: I) -> O {
        if input is ErrorCommonConformType {
            return ErrorCommon(error: input)
        } else {
            return ErrorCommon(error: nil)
        }
    }
}
