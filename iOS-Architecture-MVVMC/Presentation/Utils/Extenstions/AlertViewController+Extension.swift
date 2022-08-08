import UIKit

extension UIAlertController {
    /// Alert Untils All Setting
    static func createAlertUtils(alert: AlertModel) -> UIAlertController {
        let alertController = UIAlertController(title: alert.title,
                                                message: alert.message,
                                                preferredStyle: alert.type)
        alert.actions.forEach { action in
            let act = UIAlertAction(title: action.name, style: action.style ?? .cancel, handler: action.action)
            alertController.addAction(act)
        }
        return alertController
    }

    /// Alert not call back actions
    static func alertMessage(message: String, button: ButtonModel = ButtonModel(name: Strings.Common.cancelButton)) -> UIAlertController {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .alert)

        alertController.addAction(UIAlertAction(title: button.name, style: button.style ?? .cancel, handler: button.action))
        return alertController
    }

    /// Alert from sheet not call back actions
    static func sheetAlertMessage(message: String, button: String = Strings.Common.cancelButton) -> UIAlertController {
        let alertController = UIAlertController(title: "",
                                                message: message,
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: button, style: .cancel))
        return alertController
    }

    /// Alert Defaults have title and message
    static func alertDefault(title: String, message: String, buttons: [ButtonModel]? = [ButtonModel(name: Strings.Common.okMessage)]) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .alert)
        buttons?.forEach { action in
            let act = UIAlertAction(title: action.name, style: action.style ?? .cancel, handler: action.action)
            alertController.addAction(act)
        }
        return alertController
    }

    /// Sheet Alert Defaults have title and message
    static func sheetAlertDefaults(title: String, message: String, buttons: [ButtonModel]? = [ButtonModel(name: Strings.Common.okMessage)]) -> UIAlertController {
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .actionSheet)
        buttons?.forEach { action in
            let act = UIAlertAction(title: action.name, style:  action.style ?? .cancel, handler: action.action)
            alertController.addAction(act)
        }
        return alertController
    }
}
