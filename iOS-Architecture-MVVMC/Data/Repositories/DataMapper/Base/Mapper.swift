//
//  BaseMapping.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/31.
//

import Foundation

public protocol Mapper {
    associatedtype I
    associatedtype O
    func map(_ input: I) -> O
}
