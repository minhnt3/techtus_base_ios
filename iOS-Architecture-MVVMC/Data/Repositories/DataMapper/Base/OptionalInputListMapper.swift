//
//  OptionalInputListMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/31.
//

import Foundation

public protocol OptionalInputListMapperType {
    associatedtype I
    associatedtype O
    func map(_ input: [I]?) -> [O]
}

public struct OptionalInputListMapper<M: Mapper>: OptionalInputListMapperType {
    public typealias I = M.I
    public typealias O = M.O

    private let mapper: M

    public init(_ mapper: M) {
        self.mapper = mapper
    }

    /// returns empty if the input is nil
    public func map(_ input: [M.I]?) -> [M.O] {
        input?.map { mapper.map($0) } ?? []
    }
}
