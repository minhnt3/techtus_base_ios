//
//  String+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/05/20.
//

import Foundation
import UIKit

extension String {
    var localized: String {
        if let country = AppAppearance.countryConstantApp {
            return setLocalized(using: nil, in: .main, country: country)
        }
        if let country = CountrysSignature(rawValue: AppData.languageCode) {
            return setLocalized(using: nil, in: .main, country: country)
        }
        return localized(using: nil, in: .main)
    }

    /// replaces NSLocalizedString.
    /// - Parameters:
    ///   - tableName: The receiver’s string table to search. If tableName is `nil` or is an empty string, the method attempts to use `Localizable.strings`.
    ///   - bundle: The receiver’s bundle to search. If bundle is `nil`, the method attempts to use main bundle.
    /// - Returns: The localized string.
    func setLocalized(using tableName: String?, in bundle: Bundle?, country: CountrysSignature) -> String {
        let bundle: Bundle = bundle ?? .main
        if let path = bundle.path(forResource: Localize.setLanguage(country: country), ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        } else if let path = bundle.path(forResource: AppConstants.Localizes.kBaseBundle, ofType: "lproj"),
                  let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }

    /// replaces NSLocalizedString.
    /// - Parameters:
    ///   - tableName: The receiver’s string table to search. If tableName is `nil` or is an empty string, the method attempts to use `Localizable.strings`.
    ///   - bundle: The receiver’s bundle to search. If bundle is `nil`, the method attempts to use main bundle.
    /// - Returns: The localized string.
    func localized(using tableName: String?, in bundle: Bundle?) -> String {
        let bundle: Bundle = bundle ?? .main
        if let path = bundle.path(forResource: Localize.currentLanguage(), ofType: "lproj"),
           let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        } else if let path = bundle.path(forResource: AppConstants.Localizes.kBaseBundle, ofType: "lproj"),
                  let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: tableName)
        }
        return self
    }

    var trimSpaceAndNewLine: String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

extension String {
    func nsRange(from range: Range<String.Index>) -> NSRange {
        return NSRange(range, in: self)
    }

    func ranges(of searchString: String, options mask: NSString.CompareOptions = [], locale: Locale? = nil) -> [Range<String.Index>] {
        var ranges: [Range<String.Index>] = []
        while let range = range(of: searchString, options: mask, range: (ranges.last?.upperBound ?? startIndex) ..< endIndex, locale: locale) {
            ranges.append(range)
        }
        return ranges
    }

    func nsRanges(of searchString: String, options mask: NSString.CompareOptions = [], locale: Locale? = nil) -> [NSRange] {
        let ranges = self.ranges(of: searchString, options: mask, locale: locale)
        return ranges.map { nsRange(from: $0) }
    }

    // Regex
    func matches(pattern: String, ignoreCase: Bool = false) -> [NSTextCheckingResult]? {
        if let regex = NSRegularExpression.regex(pattern: pattern, ignoreCase: ignoreCase) {
            let range = NSRange(location: 0, length: count)
            return regex.matches(in: self, options: [], range: range).map { $0 }
        }
        return nil
    }

    func contains(pattern: String, ignoreCase: Bool = false) -> Bool? {
        if let regex = NSRegularExpression.regex(pattern: pattern, ignoreCase: ignoreCase) {
            let range = NSRange(location: 0, length: count)
            return regex.firstMatch(in: self, options: [], range: range) != nil
        }
        return nil
    }

    func replace(pattern: String, withString replacementString: String, ignoreCase: Bool = false) -> String? {
        if let regex = NSRegularExpression.regex(pattern: pattern, ignoreCase: ignoreCase) {
            let range = NSRange(location: 0, length: count)
            return regex.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: replacementString)
        }
        return nil
    }

    func validate(regex: String) -> Bool {
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: self)
    }

    func regex(pattern: String) -> Bool {
        let regexText = NSPredicate(format: "SELF MATCHES %@", pattern)
        return regexText.evaluate(with: self)
    }

    var isEmail: Bool {
        return regex(pattern: Regex.email)
    }

    var isNumberic: Bool {
        return regex(pattern: Regex.numberic)
    }

    func toUrl() -> URL? {
        return URL(string: self)
    }

    // Convert to date
    func convertToDate(format: String, localized: Bool) -> Date {
        if localized {
            return Date(str: self, format: format, isUTC: false)
        } else {
            let utcDate = Date(str: self, format: format, isUTC: true)
            let timestamp = utcDate.timeIntervalSince1970 + Double(TimeZone.current.secondsFromGMT())
            return Date(timeIntervalSince1970: timestamp)
        }
    }

    func convertToDate(format: DateFormat, localized: Bool) -> Date {
        if localized {
            return Date(str: self, format: format.rawValue, isUTC: false)
        } else {
            let utcDate = Date(str: self, format: format.rawValue, isUTC: true)
            let timestamp = utcDate.timeIntervalSince1970 + Double(TimeZone.current.secondsFromGMT())
            return Date(timeIntervalSince1970: timestamp)
        }
    }
}
