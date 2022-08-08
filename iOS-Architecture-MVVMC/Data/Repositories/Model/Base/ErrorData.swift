//
//  ErrorData.swift
//  iOS-Architecture-MVVMC
//
//  Created by NALS_MACBOOK_207 on 09/06/2022.
//

import Foundation

struct ErrorData: Decodable {
    let id: Int
    let errorCode: String?
    let title: String?
    let message: String?
    let description: String?
}
