//
//  PagingList.swift
//  iOS-Architecture-MVVMC
//
//  Created by Vu Le Van on 2022/06/01.
//

import Foundation

struct PagingList<T> {
    let data: [T]
    let next: Int?
    let offset: Int?
    let total: Int?
}

extension PagingList {
    var isLastPage: Bool {
        return data.isEmpty || next == nil
    }
}
