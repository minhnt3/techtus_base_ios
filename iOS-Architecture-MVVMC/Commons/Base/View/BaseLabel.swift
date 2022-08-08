//
//  BaseLabel.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 25/05/2022.
//

import UIKit
typealias VoidAction = () -> Void
class BaseLabel: UILabel {
    var onTap: VoidAction? {
        didSet {
            self.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(_onTap)))
        }
    }
    @objc private func _onTap() {
        onTap?()
    }
}
