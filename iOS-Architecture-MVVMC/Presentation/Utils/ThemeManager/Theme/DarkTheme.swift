//
//  DarkTheme.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 04/07/2022.
//

import UIKit

struct DarkTheme: ThemeStyle {
    var titleColor: UIColor {
        return UIColor.white
    }

    var primaryColor: UIColor {
        return UIColor.brown
    }

    var secondaryColor: UIColor {
        return UIColor(hexString: "D3D3D3")
    }
}
