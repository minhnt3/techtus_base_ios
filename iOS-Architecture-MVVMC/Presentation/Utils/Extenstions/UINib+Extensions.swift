//
//  UINib.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import UIKit

extension UINib {
    static func nib(withName nibName: String) -> UINib {
        return UINib(nibName: nibName, bundle: nil)
    }
}
