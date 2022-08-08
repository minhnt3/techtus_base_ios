//
//  Result+Extensions.swift
//  iOS-Architecture-MVVMC
//

import Foundation

extension Result {
    func doSucces(value: @escaping (Success) -> Void) {
        switch self {
        case let .success(success):
            value(success)
        case .failure:
            break
        }
    }

    func doFailue(value: @escaping (Failure) -> Void) {
        switch self {
        case .success:
            break
        case let .failure(failure):
            value(failure)
        }
    }
}
