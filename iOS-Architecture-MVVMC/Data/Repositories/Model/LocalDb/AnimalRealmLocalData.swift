//
//  AnimalRealmLocalData.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_139 on 07/07/2022.
//

import Foundation
import RealmSwift

class AnimalRealmLocalData: RealmSwift.Object {
    @Persisted(primaryKey: true) var id = ""
    @Persisted var name = ""
    @Persisted var weight = 0
}
