//
//  OptionalListMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/31.
//

import Foundation

public protocol OptionalListMapperType {
    associatedtype I
    associatedtype O
    func map(_ input: [I]?) -> [O]?
}

public struct OptionalListMapper<M: Mapper>: OptionalListMapperType {
    public typealias I = M.I
    public typealias O = M.O

    private let mapper: M

    public init(_ mapper: M) {
        self.mapper = mapper
    }

    /// returns nil if the input nil or empty
    public func map(_ input: [M.I]?) -> [M.O]? {
       input == nil || input!.isEmpty ? nil : input!.map { mapper.map($0) }
    }
}
