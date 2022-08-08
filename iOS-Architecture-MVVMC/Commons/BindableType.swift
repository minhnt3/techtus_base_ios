//
//  BindableType.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation
import UIKit

protocol ViewModelType {}

protocol BindableType: AnyObject {
    associatedtype ViewModelType
    var viewModel: ViewModelType! { get set }
    func bindViewModel()
    func setupLanguagueText()
}

extension BindableType where Self: UIView {
    func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        bindViewModel()
        setupLanguagueText()
    }
}

extension BindableType where Self: UIViewController {
    func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
        setupLanguagueText()
    }
}
