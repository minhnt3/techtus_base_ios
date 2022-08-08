//
//  ListMapper.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/31.
//

import Foundation

public protocol ListMapperType {
    associatedtype I
    associatedtype O
    func map(_ input: [I]) -> [O]
}

public struct ListMapper<M: Mapper>: ListMapperType {
    public typealias I = M.I
    public typealias O = M.O

    private let mapper: M

    public init(_ mapper: M) {
        self.mapper = mapper
    }

    /// returns the desired list
    public func map(_ input: [M.I]) -> [M.O] {
        input.map { mapper.map($0) }
    }
}
