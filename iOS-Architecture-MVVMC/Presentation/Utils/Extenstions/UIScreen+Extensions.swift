//
//  UIScreen+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 15/06/2022.
//

import UIKit

public extension UIScreen {
    class var width: CGFloat {
        return main.bounds.size.width
    }
    class var height: CGFloat {
        return main.bounds.size.height
    }
    class var scaleValue: CGFloat {
        return main.scale
    }
    class var size: CGSize {
        return main.bounds.size
    }
}
