//
//  BaseViewModel.swift
//  iOS-Architecture-MVVMC
//
//  Created by Trieu Nguyen Dinh Hai on 23/05/2022.
//

import Foundation

protocol StateCommon {
    var state: Observable<ViewState> { get }
}

class BaseViewModel: ViewModelType, StateCommon {
    var state: Observable<ViewState> = Observable()

    func handleRefreshTokenError(_ error: Error) {
        guard let error = error as? ServiceError, let errorType = error.serviceErrorType else { return }
        guard case .refreshToken = errorType else { return }
        print("refresh token failed")
        // do something like show alert or force logout
    }

    // MARK: Handle On Received Error

    /// override func to using custom
    func handleOnReceivedError(error: ErrorCommon) {
        showMessageFromError(error: error)
    }

    /// override func to using custom
    func showMessageFromError(error: ErrorCommon) {
        switch error.type {
        case let .service(error):
            state.value = ViewState.showAlert(AlertModel(title: Strings.Common.errorTitle, message: error.message ?? ""))
        case let .local(error):
            state.value = ViewState.showAlert(AlertModel(title: Strings.Common.errorTitle, message: error.message ?? ""))
        default:
            break
        }
    }

    func usingAction<S, F: Error>(fromUseCase listener: Observable<Result<S, F>>?,
                                  doSuccess: @escaping (S) -> Void = { _ in },
                                  doFailure: ((F) -> Void)? = nil) {
        state.value = .showLoading(true)
        listener?.observe(on: self) { [weak self] result in
            guard let self = self,
                  let result = result else { return }
            self.state.value = .showLoading(false)
            result.doSucces(value: { value in
                doSuccess(value)
            })
            result.doFailue(value: { error in
                guard let doFailure = doFailure else {
                    self.handleOnReceivedError(error: ErrorCommon(error: error))
                    return
                }
                doFailure(error)
            })
        }
    }
}
