//
//  BaseView.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 26/05/2022.
//

import UIKit

class BaseView: UIView, ReactiveViewProtocol {

    var onTap: VoidAction? {
        didSet {
            self.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(_onTap)))
        }
    }

    @objc private func _onTap() {
        onTap?()
    }

    func bind(_ viewModel: BaseCellViewModel?) {}

    func setupStyle(theme: Theme) {}

}

extension BaseView {
    class func instance(fromNib nibname: String) -> UIView {
        return UINib(nibName: nibname, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! BaseView
    }
}
