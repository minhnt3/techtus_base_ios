//
//  BaseCellViewModel.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 17/06/2022.
//

import UIKit

protocol ReactiveViewProtocol {
    func bind(_ viewModel: BaseCellViewModel?)
}

class BaseCellViewModel: NSObject {
    var nibName = ""
    var height: CGFloat?
    var size: CGSize?
    var title: String?
}
