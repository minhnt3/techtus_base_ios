//
//  DataResponse.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 06/06/2022.
//

import Foundation

class DataResponse<Response: Decodable>: BaseResponse {
    let data: Response?

    private enum CodingKeys: String, CodingKey {
        case data
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        data = try container.decodeIfPresent(Response.self, forKey: .data)
        try super.init(from: decoder)
    }
}
