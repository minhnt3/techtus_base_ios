//
//  OptionalOutputListMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/31.
//

import Foundation
public protocol OptionalOutputListMapperType {
    associatedtype I
    associatedtype O
    func map(_ input: [I]) -> [O]?
}

public struct OptionalOutputListMapper<M: Mapper>: OptionalOutputListMapperType {
    public typealias I = M.I
    public typealias O = M.O

    private let mapper: M

    public init(_ mapper: M) {
        self.mapper = mapper
    }

    /// returns nil if the input is empty
    public func map(_ input: [M.I]) -> [M.O]? {
        input.isEmpty ? nil : input.map { mapper.map($0) }
    }
}
