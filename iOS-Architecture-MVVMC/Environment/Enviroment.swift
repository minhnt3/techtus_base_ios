//
//  Enviroment.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/06/30.
//

import Foundation
public enum Environment {
    enum Keys {
        static let baseUrl = "BASE_URL"
    }

    // MARK: - Plist
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("Plist file not found")
        }
        return dict
    }()

    // MARK: - Plist values
    static let baseUrl: URL = {
        guard let rootURLstring = Environment.infoDictionary[Keys.baseUrl] as? String else {
            fatalError("Root URL not set in plist for this environment")
        }
        guard let url = URL(string: rootURLstring) else {
            fatalError("Root URL is invalid")
        }
        return url
    }()
}
