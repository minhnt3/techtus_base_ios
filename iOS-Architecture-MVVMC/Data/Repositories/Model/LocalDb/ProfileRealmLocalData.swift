//
//  ProfileRealmLocalData.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 15/07/2022.
//

import Foundation
import RealmSwift

class ProfileRealmLocalData: RealmSwift.Object {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var name = ""
    @Persisted var avatar = ""
    @Persisted var email = ""
    @Persisted var phone = ""
    @Persisted var city = ""
}
