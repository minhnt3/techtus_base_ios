//
//  DictionaryTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

@testable import iOS_Architecture_MVVMC
import XCTest

class DictionaryTest: XCTestCase {

    let dic: [String: Int] = ["1": 1]
    
    func testAppend() {
        var dicAppend: [String: Int] = [:]
        dicAppend.append(dic)
        XCTAssertTrue(dicAppend == dic)
        
        var dicAppend2: [String: Any] = [:]
        dicAppend2.append(dic)
        XCTAssertTrue(dicAppend2.keys.first == dic.keys.first)
        XCTAssertTrue(dicAppend2.values.first as? Int == dic.values.first)
        XCTAssertTrue(dicAppend2 as? [String: Int] == dic)
        var dicAppend3: [String: Any] = ["aaa": 1.51]
        dicAppend3.append(dic)
        XCTAssertTrue(dicAppend2.contains(where: { dic2 in
            ( dic2.key == dic.keys.first && dic2.value as? Int == dic.values.first)
        }) == true)
    }

}
