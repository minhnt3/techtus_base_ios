//
//  LocalDbErrorMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 05/07/2022.
//

import Foundation

class LocalDbErrorMapper: Mapper {
    typealias I = Error
    typealias O = LocalError

    func map(_ input: Error) -> LocalError {
        return LocalError(message: input.localizedDescription)
    }
}
