//
//  UIEdgeInsets+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 15/06/2022.
//

import UIKit

extension UIEdgeInsets {
    // Creates a new instance with all insets set to `inset`.
    init(inset: CGFloat) {
        self.init(horizontalInset: inset, verticalInset: inset)
    }

    // Creates a new instance with `left` and `right` set to `horizontalInset` and `top` and `bottom` set to `verticalInset`.
    init(horizontalInset: CGFloat, verticalInset: CGFloat) {
        self.init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
    }

    // Sets `top` and `bottom` set to `verticalInset`.
    mutating func set(verticalInset inset: CGFloat) {
        top = inset
        bottom = inset
    }

    // Sets `left` and `right` to `horizontalInset`.
    mutating func set(horizontalInset inset: CGFloat) {
        left = inset
        right = inset
    }
}
