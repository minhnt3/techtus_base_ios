//
//  UIFontDescriptor+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 15/06/2022.
//

import UIKit

extension UIFontDescriptor {
     class func changeItalicFont(fontName: String) -> UIFontDescriptor {
          let matrix = CGAffineTransform(a: 1, b: 0, c: tan(15 * CGFloat(Double.pi) / 180), d: 1, tx: 0, ty: 0)
          return UIFontDescriptor(name: fontName, matrix: matrix)
     }
}
