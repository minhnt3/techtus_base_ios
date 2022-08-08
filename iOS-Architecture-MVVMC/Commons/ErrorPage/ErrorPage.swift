import UIKit

struct ErrorPage {
    static func createErrorPage(message: String, action: @escaping () -> Void) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let buton = UIAlertAction(title: Strings.Common.cancelButton, style: .cancel) { _ in
            action()
        }
        alert.addAction(buton)
        showErrorPage(viewController: alert)
    }

    static func createErrorPageView(title: String,
                                    message: String,
                                    action: @escaping () -> Void,
                                    anyAction: (() -> Void)?) {
        let view = ErrorPageView.instanceFromNib()
        if let anyAction = anyAction {
            view.setup(title: title, message: message, action: action, anyAction: anyAction)
        } else {
            view.setup(title: title, message: message, action: action, anyAction: nil)
        }
        showErrorPage(view: view)
    }

    static func showErrorPage(view: UIView) {
        if let rootView = UIWindow.key?.rootViewController {
            view.translatesAutoresizingMaskIntoConstraints = true
            let viewVC = UIViewController()
            viewVC.view.backgroundColor = .gray.withAlphaComponent(0.5)
            viewVC.view.isUserInteractionEnabled = true
            viewVC.modalPresentationStyle = .overFullScreen
            viewVC.view.addSubview(view)
            rootView.dismiss(animated: true, completion: nil)
            rootView.present(viewVC, animated: false, completion: nil)
        }
    }

    static func showErrorPage(viewController: UIViewController) {
        if let rootWindow = UIApplication.shared.delegate?.window {
            if let rootView = rootWindow?.rootViewController {
                viewController.modalPresentationStyle = .fullScreen
                rootView.present(viewController, animated: false, completion: nil)
            }
        }
    }

    static func dissmiss() {
        if let rootView = UIWindow.key?.rootViewController {
            rootView.dismiss(animated: true, completion: nil)
        }
    }
}
