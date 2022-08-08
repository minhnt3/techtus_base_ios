//
//  Strings.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation
import UIKit

struct Strings {
    // MARK: Name of Class want to define
    // Text define conform: Name + (Type Control/Message/Title)
    struct Common {
        static var okMessage: String { return "common.message.ok".localized }
        static var errorTitle: String { return "common.title.error".localized }
        static var cancelButton: String { return "common.button.cancel".localized }
        static var localHaveResponseMessage: String { "common.message.local_have_response".localized }
        static var localCustomMessage: String { return "common.message.local_custom".localized }
        static var localAnyMessage: String { return "common.message.local_any".localized }
        static var serviceTimeOutMessage: String { return "common.message.service_time_out".localized }
        static var serviceUrlMessage: String { return "common.message.service_url".localized }
        static var serviceJsonMessage: String { return "common.message.service_json".localized }
        static var serviceLocalizedMessage: String { return "common.message.service_localized".localized }
        static var serviceNointernetMessage: String { return "common.message.service_nointernet".localized }
        static var serviceHaveResponseMessage: String { return "common.message.service_have_response".localized }
        static var serviceStatuscodeMessage: String { return "common.message.service_statuscode".localized }
        static var serviceCustomMessage: String { return "common.message.service_custom".localized }
        static var serviceAnyMessage: String { return "common.message.service_any".localized }
        static var serviceNoDataMessage: String { return "common.message.service_nodata".localized }
        static var serviceMapFromJsonKeyMessage: String { return "common.message.service_maping_key_json".localized }
        static var serviceEncodeDataFailMessage: String { return "common.message.service_encode_data".localized }
        static var serviceParamInputNotworkMessage: String { return "common.message.service_input_param".localized }
        static var serviceRefreshTokenFailedMessage: String { return "common.message.service_refresh_token".localized }
    }

    struct LoginScreen {
        static var titleLabel: String { return "loginscreen.label.login".localized }
        static var userNameLabel: String { return "loginscreen.label.user_name".localized }
        static var passwordLabel: String { return "loginscreen.label.password" .localized }
        static var loginButton: String { return "loginscreen.button.login".localized }
        static var enterUserNameMessage: String { return "loginscreen.message.enter_name".localized }
        static var enterUsernameLeastCharacterMessage: String { return "loginscreen.message.enter_user".localized }
        static var enterPasswordMessage: String { return "loginscreen.message.enter_password".localized }
        static var enterPasswordLeastCharacterMessage: String { return "loginscreen.message.enter_password_least".localized }
        static var loginSuccessfulMessage: String { return "loginscreen.message.login_success".localized }
    }

    struct AnimalsScreen {
        static var title: String { return "animalsscreen.title".localized }
    }

    struct ProfileScreen {
        static var title: String { return "profilescreen.title".localized }
        static var nameLabel: String { return "profilescreen.label.name".localized }
        static var emailLabel: String { return "profilescreen.label.email".localized }
        static var phoneLabel: String { return "profilescreen.label.phone".localized }
        static var cityLabel: String { return "profilescreen.label.city".localized }
    }
}
