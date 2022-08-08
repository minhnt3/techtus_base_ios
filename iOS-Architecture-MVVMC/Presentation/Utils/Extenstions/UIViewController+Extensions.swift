//
//  UIViewController+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation
import UIKit

protocol ViewControllerLifecycleBehavior {
    func viewDidLoad(viewController: UIViewController)
    func viewWillAppear(viewController: UIViewController)
    func viewDidAppear(viewController: UIViewController)
    func viewWillDisappear(viewController: UIViewController)
    func viewDidDisappear(viewController: UIViewController)
    func viewWillLayoutSubviews(viewController: UIViewController)
    func viewDidLayoutSubviews(viewController: UIViewController)
}

// Default implementations
extension ViewControllerLifecycleBehavior {
    func viewDidLoad(viewController: UIViewController) {}
    func viewWillAppear(viewController: UIViewController) {}
    func viewDidAppear(viewController: UIViewController) {}
    func viewWillDisappear(viewController: UIViewController) {}
    func viewDidDisappear(viewController: UIViewController) {}
    func viewWillLayoutSubviews(viewController: UIViewController) {}
    func viewDidLayoutSubviews(viewController: UIViewController) {}
}

extension UIViewController {
    /*
     Add behaviors to be hooked into this view controller’s lifecycle.

     This method requires the view controller’s view to be loaded, so it’s best to call
     in `viewDidLoad` to avoid it being loaded prematurely.

     - parameter behaviors: Behaviors to be added.
     */
    func addBehaviors(_ behaviors: [ViewControllerLifecycleBehavior]) {
        let behaviorViewController = LifecycleBehaviorViewController(behaviors: behaviors)
        addChild(behaviorViewController)
        view.addSubview(behaviorViewController.view)
        behaviorViewController.didMove(toParent: self)
    }

    private final class LifecycleBehaviorViewController: UIViewController, UIGestureRecognizerDelegate {
        private let behaviors: [ViewControllerLifecycleBehavior]

        // MARK: - Lifecycle

        init(behaviors: [ViewControllerLifecycleBehavior]) {
            self.behaviors = behaviors
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewDidLoad() {
            super.viewDidLoad()
            view.isHidden = true
            applyBehaviors { behavior, viewController in
                behavior.viewDidLoad(viewController: viewController)
            }
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            applyBehaviors { behavior, viewController in
                behavior.viewWillAppear(viewController: viewController)
            }
        }

        override func viewDidAppear(_ animated: Bool) {
            super.viewDidAppear(animated)
            applyBehaviors { behavior, viewController in
                behavior.viewDidAppear(viewController: viewController)
            }
        }

        override func viewWillDisappear(_ animated: Bool) {
            super.viewWillDisappear(animated)
            applyBehaviors { behavior, viewController in
                behavior.viewWillDisappear(viewController: viewController)
            }
        }

        override func viewDidDisappear(_ animated: Bool) {
            super.viewDidDisappear(animated)
            applyBehaviors { behavior, viewController in
                behavior.viewDidDisappear(viewController: viewController)
            }
        }

        override func viewWillLayoutSubviews() {
            super.viewWillLayoutSubviews()
            applyBehaviors { behavior, viewController in
                behavior.viewWillLayoutSubviews(viewController: viewController)
            }
        }

        override func viewDidLayoutSubviews() {
            super.viewDidLayoutSubviews()
            applyBehaviors { behavior, viewController in
                behavior.viewDidLayoutSubviews(viewController: viewController)
            }
        }

        // MARK: - Private

        private func applyBehaviors(body: (_ behavior: ViewControllerLifecycleBehavior, _ viewController: UIViewController) -> Void) {
            guard let parent = parent else { return }

            for behavior in behaviors {
                body(behavior, parent)
            }
        }

        func add(child: UIViewController, container: UIView) {
            addChild(child)
            child.view.frame = container.bounds
            container.addSubview(child.view)
            child.didMove(toParent: self)
        }

        func remove() {
            guard parent != nil else {
                return
            }
            willMove(toParent: nil)
            removeFromParent()
            view.removeFromSuperview()
        }
    }
}

// MARK: Show loading

extension UIViewController {
    func showLoading(title titleLoading: String?, loadingView loading: LoadingView) {
        if let titleLoading = titleLoading {
            loading.showLoading(with: titleLoading)
        } else {
            loading.handleLoading(true)
        }
        view.addSubview(loading)
        view.widthAnchor.constraint(equalTo: loading.widthAnchor).isActive = true
        view.heightAnchor.constraint(equalTo: loading.heightAnchor).isActive = true
        view.bringSubviewToFront(loading)
    }

    func hideLoading(loadingView loading: LoadingView) {
        view.isUserInteractionEnabled = true
        loading.handleLoading(false)
        loading.removeFromSuperview()
    }
}

// MARK: AlertUntil

extension UIViewController {
    /// Show message Alert
    func showAlertDefault(message: String,
                          title: String = "",
                          butons: [ButtonModel]? = nil,
                          animated: Bool = false) {
        let alert = UIAlertController.alertDefault(title: title,
                                                   message: message,
                                                   buttons: butons ?? [])
        present(alert, animated: animated)
    }

    /// Show Sheet Message Alert
    func showSheetDefault(message: String,
                          title: String = "",
                          butons: [ButtonModel]? = nil,
                          animated: Bool = false) {
        let alert = UIAlertController.sheetAlertDefaults(title: title,
                                                         message: message,
                                                         buttons: butons)
        present(alert, animated: animated)
    }

    func showAlertUntils(alert: AlertModel, animated: Bool = false) {
        let alert = UIAlertController.createAlertUtils(alert: alert)
        present(alert, animated: animated)
    }
}
