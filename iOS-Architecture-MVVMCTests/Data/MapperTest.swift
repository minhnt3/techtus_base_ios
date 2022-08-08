//
//  MapperTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by Vu Le Van on 2022/05/31.
//

import XCTest
@testable import iOS_Architecture_MVVMC

class MapperTest: XCTestCase {
    
    private var user: UserData!
    private var users: [UserData]!
    
    override func setUp() {
        user = UserData(name: "van vu", email: "vulv@nal.vn")
        users = [
            UserData(name: "van vu", email: "vulv1@nal.vn"),
            UserData(name: "van vu 1", email: "vulv2@nal.vn"),
            UserData(name: "van vu 2", email: "vulv3@nal.vn")
        ]
    }
    
    func testMap_returnCorrectOutput() {
        let userModel = UserDataMapper().map(user)
        XCTAssertEqual(userModel.name, user.name)
        XCTAssertEqual(userModel.email, user.email)
    }
    
    func testListMap_returnCorrectOutput() {
        let usersModel = ListMapper(UserDataMapper()).map(users)
        usersModel.enumerated().forEach { (index, user) in
            XCTAssertEqual(user.email, users[index].email)
        }
    }
}
