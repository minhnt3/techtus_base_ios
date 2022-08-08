//
//  BaseResponse.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 06/06/2022.
//

import Foundation

class BaseResponse: Decodable {
    let success: Bool
    let status: Int
}
