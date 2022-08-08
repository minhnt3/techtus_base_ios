//
//  Float.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import UIKit

extension Float {
    var degreesToRadians: Self {
        return self * .pi / 180
    }

    var radiansToDegrees: Self {
        return self * 180 / .pi
    }
}
