//
//  FloatTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

@testable import iOS_Architecture_MVVMC
import XCTest

class FloatTest: XCTestCase {

    let degrees: Float = 100.0

    let radian: Float = 1.74532925
    func testConvert() {
        let degrees1 = radian.radiansToDegrees
        
        let radian1 = degrees1.degreesToRadians
        
        let radian2 = degrees.degreesToRadians
        
        let degrees2 = radian2.radiansToDegrees
        
        XCTAssertTrue(radian == radian1)
        XCTAssertTrue(degrees2 == degrees)
    }
}
