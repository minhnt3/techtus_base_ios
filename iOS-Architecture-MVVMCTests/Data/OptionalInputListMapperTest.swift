//
//  OptionalInputMapperTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by Vu Le Van on 2022/05/31.
//

import XCTest
@testable import iOS_Architecture_MVVMC

class OptionalInputListMapperTest: XCTestCase {
    
    private var users: [UserData]?
    
    override func setUp() {
        users = [
            UserData(name: "van vu", email: "vulv1@nal.vn"),
            UserData(name: "van vu 1", email: "vulv2@nal.vn"),
            UserData(name: "van vu 2", email: "vulv3@nal.vn")
        ]
    }
    
    func testMap_returnCorrectOutput() {
        let usersModel = OptionalInputListMapper(UserDataMapper()).map(users)
        XCTAssert(usersModel.count == 3)
        usersModel.enumerated().forEach { (index, user) in
            XCTAssertEqual(user.email, users?[index].email)
        }
    }
    
    func testMap_returnEmptyList() {
        users = nil
        let usersModel = OptionalInputListMapper(UserDataMapper()).map(users)
        XCTAssert(usersModel.isEmpty)
    }
}
