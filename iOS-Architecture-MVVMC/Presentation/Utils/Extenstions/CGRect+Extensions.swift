//
//  CGRect+Extension.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import UIKit

extension CGRect {
    var x: CGFloat {
        get {
            return origin.x
        }
        set {
            origin.x = newValue
        }
    }

    var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin.y = newValue
        }
    }

    var width: CGFloat {
        // swiftlint:disable all
        get {
            return size.width
        }

        set {
            size.width = newValue
        }
    }

    var height: CGFloat {
        // swiftlint:disable all
        get {
            return size.height
        }
        set {
            size.height = newValue
        }
    }

    var halfWidth: CGFloat { return width / 2 }
    var halfHeight: CGFloat { return height / 2 }
    var center: CGPoint { return CGPoint(x: halfWidth, y: halfHeight) }

    func add(rect: CGRect) {
        _ = union(rect)
    }

    mutating func size(size: CGSize) {
        width = size.width
        height = size.height
    }
}
