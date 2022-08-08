//
//  BaseReusableView.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 20/06/2022.
//

import UIKit

class BaseReusableView: UICollectionReusableView, ReactiveViewProtocol {

    func bind(_ viewModel: BaseCellViewModel?) {}

    func setupStyle(theme: Theme) {}
}
