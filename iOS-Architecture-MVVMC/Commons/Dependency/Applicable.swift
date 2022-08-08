//
//  Applicable.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/07/12.
//

import Foundation
protocol Applicable {}

extension Applicable {

    /// Call methods of a closure from inside an object.
    func apply(_ closure: (Self) -> Void) {
        closure(self)
    }
}
