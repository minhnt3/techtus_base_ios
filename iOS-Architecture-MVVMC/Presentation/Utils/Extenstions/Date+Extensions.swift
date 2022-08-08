//
//  Date+Extensions.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

import Foundation

extension Date {
    init(str: String, format: String, isUTC: Bool) {
        let fmt = DateFormatter.fromFormat(format: format)
        fmt.timeZone = isUTC ? TimeZone.utcTimeZone() : TimeZone.current
        if let date = fmt.date(from: str) {
            self.init(timeInterval: 0, since: date)
        } else {
            self.init(timeInterval: 0, since: Date.zero)
        }
    }

    static func randomBetween(start: String, end: String, format: String = "yyyy/MM/dd") -> String {
        let date1 = Date.parse(start, format: format)
        let date2 = Date.parse(end, format: format)
        return Date.randomBetween(start: date1, end: date2).dateString(format)
    }

    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow ... date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }

    static func parse(_ string: String, format: String = "yyyy/MM/dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }

    func dateString(_ format: String = "yyyy/MM/dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static var now: Date {
        return Date()
    }

    var timestamp: TimeInterval {
        return timeIntervalSince1970 * 1000
    }

    static var zero: Date {
        var comps = DateComponents(year: 0, month: 1, day: 1)
        comps.timeZone = TimeZone.utcTimeZone()
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.utcTimeZone()
        return calendar.date(from: comps) ?? Date()
    }

    func toString(format: DateFormat, localize: Bool) -> String {
        let fmt = DateFormatter.fromFormat(format: format.rawValue)
        fmt.timeZone = localize ? TimeZone.current : TimeZone.utcTimeZone()
        return fmt.string(from: self)
    }

    var begin: Date {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self) ?? Date.now
    }

    var end: Date {
        return Calendar.current.date(bySettingHour: 23, minute: 59, second: 0, of: self) ?? Date.now
    }

    var yesterday: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: self) ?? Date.now
    }

    var tomorrow: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self) ?? Date.now
    }

    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self) ?? Date.now
    }

    var hour: Int {
        return Calendar.current.component(.hour, from: self)
    }

    var minute: Int {
        return Calendar.current.component(.minute, from: self)
    }

    var day: Int {
        return Calendar.current.component(.day, from: self)
    }

    var month: Int {
        return Calendar.current.component(.month, from: self)
    }

    var year: Int {
        return Calendar.current.component(.year, from: self)
    }

    var second: Int {
        return Calendar.current.component(.second, from: self)
    }

    var weekday: WeekDay {
        let weekDay = Calendar.current.component(.weekday, from: self)
        return WeekDay(rawValue: weekDay) ?? .mon
    }

    var monthEngName: String {
        let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        return months[month - 1]
    }

    func setDate(withHour hour: Int, minute: Int) -> Date {
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.current
        return calendar.date(bySettingHour: hour, minute: minute, second: 0, of: self) ?? Date.now
    }

    func hour(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .hour, value: 1, to: self) ?? Date.now
    }

    func minute(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .minute, value: value, to: self) ?? Date.now
    }

    func second(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .second, value: value, to: self) ?? Date.now
    }

    func date(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: value, to: self) ?? Date.now
    }

    func year(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .year, value: value, to: self) ?? Date.now
    }

    func month(adding value: Int) -> Date {
        return Calendar.current.date(byAdding: .month, value: value, to: self) ?? Date.now
    }

    func getLast6Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -6, to: self)
    }

    func getLast3Month() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -3, to: self)
    }

    func getYesterday() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -1, to: self)
    }

    func getLast7Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -7, to: self)
    }

    func getLast30Day() -> Date? {
        return Calendar.current.date(byAdding: .day, value: -30, to: self)
    }

    func getPreviousMonth() -> Date? {
        return Calendar.current.date(byAdding: .month, value: -1, to: self)
    }

    // This Month Start
    var startMonth: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.utcTimeZone()
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components) ?? Date.now
    }

    var endMonth: Date {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.utcTimeZone()
        let components = calendar.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month += 1
        components.day = 1
        components.day -= 1
        return calendar.date(from: components as DateComponents) ?? Date.now
    }

    // Last Month Start
    func getLastMonthStart() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.month -= 1
        return Calendar.current.date(from: components as DateComponents) ?? Date.now
    }

    // Last Month End
    func getLastMonthEnd() -> Date? {
        let components: NSDateComponents = Calendar.current.dateComponents([.year, .month], from: self) as NSDateComponents
        components.day = 1
        components.day -= 1
        return Calendar.current.date(from: components as DateComponents) ?? Date.now
    }

    func components(to day: Date) -> DateComponents {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: self, to: day)
        return components
    }

    func edit(component: Calendar.Component, value: Int) -> Date {
        switch component {
        case .hour:
            return Calendar.current.date(bySettingHour: value, minute: minute, second: second, of: self) ?? self
        case .minute:
            return Calendar.current.date(bySettingHour: hour, minute: value, second: second, of: self) ?? self
        case .second:
            return Calendar.current.date(bySettingHour: hour, minute: minute, second: value, of: self) ?? self
        default:
            return self
        }
    }
}

// MARK: - TimeZone

extension TimeZone {
    static func utcTimeZone() -> TimeZone {
        return TimeZone(secondsFromGMT: 0) ?? TimeZone.current
    }
}

// MARK: - DateFormatter

extension DateFormatter {
    static func fromFormat(format: String) -> DateFormatter {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        return fmt
    }
}

// MARK: - TimeInterval

extension TimeInterval {
    func toDate(localized: Bool) -> Date {
        if localized {
            return Date(timeIntervalSince1970: self)
        } else {
            let timeInterval = self + TimeInterval(TimeZone.current.secondsFromGMT())
            return Date(timeIntervalSince1970: timeInterval)
        }
    }
}

enum WeekDay: Int, CaseIterable {
    case sun = 1
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    var name: String {
        switch self {
        case .mon:
            return "Mon"
        case .tue:
            return "Tue"
        case .sun:
            return "Sun"
        case .wed:
            return "Wed"
        case .thu:
            return "Thu"
        case .fri:
            return "Fri"
        case .sat:
            return "Sat"
        }
    }
}

enum DateFormat: String {
    /** yyyy/MM/dd HH:mm:ss */
    case dateTime24a = "yyyy/MM/dd HH:mm:ss"
    /** yyyy-MM-dd HH:mm:ss */
    case dateTime24b = "yyyy-MM-dd HH:mm:ss"
    /** yyyy-MM-dd HH:mm:ss Z */
    case dateTime24Z = "yyyy-MM-dd HH:mm:ss Z"
    /** yyyy-MM-dd hh:mm:ss a */
    case dateTime12 = "yyyy-MM-dd hh:mm:ss a"
    /** yyyy-MM-dd hh:mm:ss a Z */
    case dateTime12Z = "yyyy-MM-dd hh:mm:ss a Z"
    /** yyyy-MM-dd HH:mm */
    case dateTime24NoSec = "yyyy-MM-dd HH:mm"
    /** yyyy-MM-dd hh:mm a */
    case dateTime12NoSec = "yyyy-MM-dd hh:mm a"
    /** yyyy-MM-dd */
    case date = "yyyy-MM-dd"
    /** HH:mm:ss */
    case time24 = "HH:mm:ss"
    /** hh:mm:ss a */
    case time12 = "hh:mm:ss a"
    /** HH:mm */
    case time24NoSec = "HH:mm"
    /** hh:mm a */
    case time12NoSec = "hh:mm a"

    /** yyyy-MM-dd'T'HH:mm:ss */
    case tDateTime = "yyyy-MM-dd'T'HH:mm:ss"
    /** yyyy-MM-dd'T'HH:mm:ss.SSS'Z' */
    case tDateTime3 = "yyyy-MM-dd'T'HH:mm:ss.SSS"
    /** yyyy-MM-dd'T'HH:mm:ss.SSSSSS */
    case tDateTime6 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS"

    case tDateTime3Z = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    /** yyyy-MM-dd'T'HH:mm:ss'Z' */
    case tzDateTime = "yyyy-MM-dd'T'HH:mm:ss'Z'"
    /** yyyy-MM-dd'T'HH:mm:ss.SSS'Z' */
    case tzDateTime3 = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    /** yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z' */
    case tzDateTime6 = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"

    /** dd/MM/yyyy */
    case dateMonthYear = "dd/MM/yyyy"
    /** dd/MM */
    case dateMonth = "MM/dd"
    /** HH:mm dd/MM/yyyy */
    case timeDateiRevoo = "HH:mm dd/MM/yyyy"
    /** "dd/MM/yyyy - HH:mm" */
    case dateTimeiRevoo = "dd/MM/yyyy - HH:mm"
    case dmyhms = "dd/MM/yyyy HH:mm:ss"
    //
    /**  */
    /** yyyy/MM//dd */
    case yearMonthDate = "yyyy/MM//dd"
    /** dd,yyyy */
    case yearEventDate = "dd,yyyy"
    /** EEEE, MMM d, yyyy. HH:mm */
    case fullYearEvent = "EEEE, MMM d, yyyy. HH:mm"
    /** EEEE d */
    case dayAndDate = "EEEE d"
    /** EEEE */
    case fullDay = "EEEE"
    /** EEEE, MMM d, yyyy */
    case fullDate = "EEEE, MMM d, yyyy"
    /** MMMM yyyy */
    case monAndYear = "MMMM yyyy"
    /** MMMM */
    case month = "MMMM"
    /** E */
    case day = "E"
    /** MMM d */
    case dateAndMonth = "MMM d"
    /** d */
    case shortDate = "d"
    /** dd */
    case shortDay = "dd"
    /** yyyy */
    case shortYear = "yyyy"
    /** HH */
    case hour = "HH"
    /** yyyy.MM.dd */
    case yyyyMMdd = "yyyy.MM.dd"
    /** MMMM EEE dd */
    case widgetDaily = "MMMM EEE dd"
    /** MM/dd */
    case monthDate = "dd/MM"
}
