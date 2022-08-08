//
//  DateTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

@testable import iOS_Architecture_MVVMC
import XCTest

class DateTest: XCTestCase {
    let yearDateString = "2022/06/16"
    let nextMonthYearDateString = "2022/07/16"
    let dateYearString = "16/06/2022"
    let nextMonthdateYearString = "16/07/2022"
    // default dateFormat yyyy/MM/dd
    func testPare() {
        let pare = Date.parse(yearDateString)
        XCTAssert(Calendar.current.component(.day, from: pare) == 16
            && Calendar.current.component(.month, from: pare) == 06
            && Calendar.current.component(.year, from: pare) == 2022
        )
    }

    // default dateFormat any
    func testPareEdit() {
        let pare = Date.parse(dateYearString, format: "dd/MM/yyyy")
        print(pare)
        XCTAssert(Calendar.current.component(.day, from: pare) == 16
            && Calendar.current.component(.month, from: pare) == 06
            && Calendar.current.component(.year, from: pare) == 2022
        )
    }

    func testRandomBetweenDate() {
        let start = Date.parse(yearDateString)
        let end = Date.parse(nextMonthYearDateString)
        let dateRandom = Date.randomBetween(start: start, end: end)
        if end < start {
            XCTAssert((end <= dateRandom && dateRandom <= start) == true)
        } else {
            XCTAssert((start <= dateRandom && dateRandom <= end) == true)
        }
    }
    
    func testRandomBetwenDateString() {
        let start = Date.parse(dateYearString, format: "dd/MM/yyyy")
        let end = Date.parse(nextMonthdateYearString, format: "dd/MM/yyyy")
        let dateRandom = Date.randomBetween(start: start, end: end)
        if end < start {
            XCTAssert((end <= dateRandom && dateRandom <= start) == true)
        } else {
            XCTAssert((start <= dateRandom && dateRandom <= end) == true)
        }
    }
    
    func testRandomBetweenDateSomeFormat() {
        let start = Date.parse(dateYearString, format: "dd/MM/yyyy")
        let end = Date.parse(nextMonthdateYearString, format: "dd/MM/yyyy")
        let dateRandom = Date.randomBetween(start: start, end: end)
        if end < start {
            XCTAssert((end <= dateRandom && dateRandom <= start) == true)
        } else {
            XCTAssert((start <= dateRandom && dateRandom <= end) == true)
        }
    }
    
    func testRandomBetwenDateStringSomeFormat() {
        let start = dateYearString
        let end = nextMonthdateYearString
        let dateRandom = Date.randomBetween(start: start, end: end, format: "dd/MM/yyyy")
        let dateStart = Date.parse(start, format: "dd/MM/yyyy")
        let dateEnd = Date.parse(end, format: "dd/MM/yyyy")
        let date = Date.parse(dateRandom, format: "dd/MM/yyyy")
        if dateEnd < dateStart {
            XCTAssert((dateEnd <= date && date <= dateStart) == true)
        } else {
            XCTAssert((dateStart <= date && date <= dateEnd) == true)
        }
    }
}
