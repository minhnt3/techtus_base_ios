//
//  Storage.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/06/21.
//

import Foundation

@propertyWrapper
struct Storage<T: Codable> {
    struct Wrapper<T> : Codable where T : Codable {
        let wrapped : T
    }
    private let key: String
    private let defaultValue: T

    init(key: String, defaultValue: T) {
        self.key = key
        self.defaultValue = defaultValue
    }

    var wrappedValue: T {
        get {
            // Read value from UserDefaults
            guard let data = UserDefaults.standard.object(forKey: key) as? Data else {
                return defaultValue
            }
            // Convert data to the desire data type
            let value = try? JSONDecoder().decode(Wrapper<T>.self, from: data)
            return value?.wrapped ?? defaultValue
        }
        set {
            do {
                let data = try JSONEncoder().encode(Wrapper(wrapped: newValue))
                UserDefaults.standard.set(data, forKey: key)
            } catch {
                print(error)
            }
        }
    }
}
