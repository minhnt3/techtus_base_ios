//
//  BaseViewController.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 23/05/2022.
//

import UIKit

enum ViewState {
    case showAlert(AlertModel)
    case showLoading(Bool)
    case showToast(String)
    case `default`
}

class BaseViewController<ViewModel: BaseViewModel>: UIViewController, BindableType {
    var viewModel: ViewModel!
    lazy var loading = LoadingView.instanceFromNib()
    var theme: Theme = ThemeManager.shared.currentTheme()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupStyle()
    }

    // need override to setup text in view
    func setupLanguagueText() {}

    func setupStyle() {}

    func bindViewModel() {
        bindState()
    }

    func bindState() {
        viewModel.state.observe(on: self) { [weak self] state in
            guard let self = self, let state = state else { return }
            self.loadState(StateOfView: state)
        }
    }

    private func loadState(StateOfView state: ViewState) {
        switch state {
        case let .showAlert(alertCustom):
            showAlertUntils(alert: alertCustom)
        case let .showLoading(isLoading):
            if isLoading {
                showLoading(title: nil, loadingView: loading)
            } else {
                hideLoading(loadingView: loading)
            }
        case let .showToast(message):
            showToast(message)
        default:
            break
        }
    }
}

extension BaseViewController: ThemeObserver {
    func changeThemeManager(_ theme: Theme) {
        self.theme = theme
        setupStyle()
    }
}
