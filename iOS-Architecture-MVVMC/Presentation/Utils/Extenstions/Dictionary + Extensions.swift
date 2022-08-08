//
//  Dictionary + Extension.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import Foundation

extension Dictionary {
    mutating func append(_ dict: [Key: Value]?) {
        guard let dict = dict else { return }
        for (key, value) in dict {
            self[key] = value
        }
    }

    func queryString() -> String {
        return compactMap { "\($0)=\($1)" }.joined(separator: "&")
    }
}
