//
//  AppApi.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 14/06/2022.
//

import Foundation

enum AppApi {
    case refreshToken
    case login(username: String, password: String)
    case animals
    case profile
}

extension AppApi: APIRequestInfo {
    var baseURL: URL {
        return Environment.baseUrl
    }

    var path: String {
        switch self {
        case .refreshToken:
            return "/refresh_token"
        case .login:
            return "/login"
        case .animals:
            return "/animals"
        case .profile:
            return "/profile"
        }
    }

    var task: APITask {
        return .requestPlain
    }

    var method: APIMethod {
        switch self {
        case .refreshToken, .animals, .profile:
            return .GET
        case .login:
            return .POST
        }
    }

    var headers: [String: String]? {
        switch self {
        default:
            return nil
        }
    }
}
