//
//  AlertUntilModel.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 13/07/2022.
//

import UIKit

struct AlertModel {
    var title: String
    var message: String
    var type: UIAlertController.Style = .alert
    var actions: [ButtonModel] = [ButtonModel(name: Strings.Common.okMessage)]
}

enum TypeAlert {
    case popup
    case actionSheet
}

struct ButtonModel {
    var name: String
    var style: UIAlertAction.Style? = .cancel
    var action: ((UIAlertAction) -> Void)?
}
