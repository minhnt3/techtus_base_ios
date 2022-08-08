//
//  UserResponse.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 06/06/2022.
//

import Foundation

class UserResponse<Response: Decodable>: BaseResponse {
    let user: Response?

    private enum CodingKeys: String, CodingKey {
        case user
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        user = try container.decodeIfPresent(Response.self, forKey: .user)
        try super.init(from: decoder)
    }
}
