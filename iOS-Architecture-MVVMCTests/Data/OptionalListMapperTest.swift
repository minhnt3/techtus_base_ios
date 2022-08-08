//
//  OptinalListMapperTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by Vu Le Van on 2022/05/31.
//

import XCTest
@testable import iOS_Architecture_MVVMC

class OptionalListMapperTest: XCTestCase {
    private var users: [UserData]?
    override func setUp() {
        users = [
            UserData(name: "van vu", email: "vulv1@nal.vn"),
            UserData(name: "van vu 1", email: "vulv2@nal.vn"),
            UserData(name: "van vu 2", email: "vulv3@nal.vn")
        ]
    }
    
    func testMap_returnCorrectOutput() {
        let usersModel = OptionalListMapper(UserDataMapper()).map(users)
        XCTAssert(usersModel?.count == 3)
        usersModel!.enumerated().forEach { (index, user) in
            XCTAssertEqual(user.email, users?[index].email)
        }
    }
    
    func testMap_returnNilIfInputNil() {
        users = nil
        let users = OptionalListMapper(UserDataMapper()).map(users)
        XCTAssert(users == nil)
    }
    
    func testMap_returnNilifInputEmpty() {
        users = []
        let users = OptionalListMapper(UserDataMapper()).map(users)
        XCTAssert(users == nil)
    }
}
