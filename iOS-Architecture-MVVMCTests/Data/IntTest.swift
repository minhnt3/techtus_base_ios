//
//  IntTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

@testable import iOS_Architecture_MVVMC
import XCTest

class IntTest: XCTestCase {
    let odd = 13
    let even = 14
    let number = 12345678
    func testOddandEven() {
        XCTAssertTrue(odd.isOdd)
        XCTAssertFalse(odd.isEven)
        XCTAssertTrue(even.isEven)
        XCTAssertFalse(even.isOdd)
    }

    func testDigits() {
        let digits = number.digits
        XCTAssertTrue(digits == [1, 2, 3, 4, 5, 6, 7, 8])
    }

    func testOperator() {
        let abs = (-13).abs
        XCTAssertTrue(abs == 13)

        let gcd = 13.gcd(4)
        XCTAssertTrue(gcd == 1)
        let gcd2 = 14.gcd(4)
        XCTAssertTrue(gcd2 == 2)
        
        let lcm = 13.lcm(3)
        XCTAssertTrue(lcm == 39)
        let lcm2 = 13.lcm(2)
        XCTAssertTrue(lcm2 == 26)
        
        let factorial = 0.factorial
        XCTAssertTrue(factorial == 1)
        let factorial2 = 3.factorial
        XCTAssertTrue(factorial2 == 6)
    }
    
    func testRandom() {
        let random = Int.random(min: odd, max: number)
        XCTAssertTrue(random > odd)
        XCTAssertTrue(random < number)
        XCTAssertFalse(random == odd)
        XCTAssertFalse(random <= odd)
        XCTAssertFalse(random == number)
        XCTAssertFalse(random >= number)
    }
}
