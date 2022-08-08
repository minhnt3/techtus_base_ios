//
//  ArrayTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by NALS_MACBOOK_207 on 16/06/2022.
//

@testable import iOS_Architecture_MVVMC
import XCTest

class ArrayTest: XCTestCase {
    let array = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]

    func testChunked() {
        let chunkArray = array.chunked(into: 3)
        XCTAssertEqual(chunkArray[0][0], array[0])
        XCTAssertEqual(chunkArray[0][1], array[1])
        XCTAssertEqual(chunkArray[0][2], array[2])
        XCTAssertEqual(chunkArray[1][0], array[3])
        XCTAssertEqual(chunkArray[1][1], array[4])
        XCTAssertEqual(chunkArray[1][2], array[5])
        XCTAssertEqual(chunkArray[2][0], array[6])
        XCTAssertEqual(chunkArray[2][1], array[7])
        XCTAssertEqual(chunkArray[2][2], array[8])
        XCTAssertEqual(chunkArray[3][0], array[9])
        XCTAssertEqual(chunkArray[3][1], array[10])
    }
    
    func testIndexOf() {
        let index = array.indexOf { i in
            i == 6
        }
        XCTAssertEqual(index, 5)
    }
    
    func testItemAt() {
        let item = array.item(at: 10)
        XCTAssertEqual(item, array[10])
        XCTAssert(item != nil)
        let item2 = array.item(at: 12)
        XCTAssertNil(item2)
    }
    
    func testItemsAt() {
        let items = array.items(at: Range(3...7))
        XCTAssertNotNil(items)
        XCTAssert(items?[0] == 4 )
    }
    
    func testRemoveDuplicate() {
        let arrays = [1,2,1,3,4,5,1,3]
        let items = arrays.removeDuplicates()
        XCTAssert((items == [1,2,3,4,5]) == true)
        XCTAssertNotNil(items)
    }
}
