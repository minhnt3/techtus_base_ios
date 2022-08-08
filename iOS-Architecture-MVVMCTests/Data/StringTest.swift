//
//  StringTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by NALS_MACBOOK_207 on 17/06/2022.
//

@testable import iOS_Architecture_MVVMC
import XCTest

class StringTest: XCTestCase {
    let emailsTrue = ["abc@gmail.com", "join.edison@gmail.com", "join.henry@outlook.com", "helen.yorn.113@mail.com"]
    let emailsFail = ["a@@abc.com", "113.112,123!@123", "bard.smith@1@soudel_113!123", "master!.com","123123123","aaabbbccc@"]
    let numericTrue = "123123123"
    let numericFail = "acbcsa123"
    let dayString = "20/06/2022 16:04:56"

    func testEmail() {
        emailsTrue.forEach {
            XCTAssertTrue($0.isEmail)
        }
        emailsFail.forEach{
            XCTAssertFalse($0.isEmail)
        }
    }
    
    func testNumeric() {
        XCTAssertTrue(numericTrue.isNumberic)
        XCTAssertFalse(numericFail.isNumberic)
    }
    
    func testConvert() {
        let date = dayString.convertToDate(format: "dd/MM/yyyy HH:mm:ss", localized: true)
        XCTAssertNotNil(date)
        XCTAssertTrue(date.day == 20)
        XCTAssertTrue(Calendar.current.component(.month, from: date) == 06)
        XCTAssertTrue(Calendar.current.component(.year, from: date) == 2022)
        XCTAssertTrue(Calendar.current.component(.minute, from: date) == 04)
        XCTAssertTrue(Calendar.current.component(.second, from: date) == 56)
        XCTAssertTrue(Calendar.current.component(.hour, from: date) == 16)
    }
}
