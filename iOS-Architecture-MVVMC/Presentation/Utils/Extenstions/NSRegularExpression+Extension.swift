//
//  NSRegularExpression.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import Foundation

extension NSRegularExpression {
    class func regex(pattern: String, ignoreCase: Bool = false) -> NSRegularExpression? {
        let options: NSRegularExpression.Options = ignoreCase ? [.caseInsensitive] : []
        var regex: NSRegularExpression?
        do {
            regex = try NSRegularExpression(pattern: pattern, options: options)
        } catch {
            regex = nil
        }
        return regex
    }
}
