//
//  APIService.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 23/05/2022.
//

import Foundation

enum APIMethod: String {
    case GET, PUT, POST, DELETE, PATCH
}

enum APIParameterEncoding {
    /// Return encoding instance with default writing options.
    /// JSONSerialization.WritingOptions = []
    case jsonEncoding
    /// Applies encoded query string result to existing query string for `GET`, `HEAD` and `DELETE` requests and
    /// sets as the HTTP body for requests with any other HTTP method.
    case urlEncoding
}

enum APITask {
    /// A request with no additional data.
    case requestPlain

    /// A requests body set with data.
    case requestData(Data)

    /// A request body set with `Encodable` type
    case requestJSONEncodable(Encodable)

    /// A request body set with `Encodable` type and custom encoder
    case requestCustomJSONEncodable(Encodable, encoder: JSONEncoder)

    /// A requests body set with encoded parameters.
    case requestParameters(parameters: [String: Any], encoding: APIParameterEncoding)

    /// A requests body set with data, combined with url parameters.
    case requestCompositeData(bodyData: Data, urlParameters: [String: Any])

    /// A requests body set with encoded parameters combined with url parameters.
    case requestCompositeParameters(
        bodyParameters: [String: Any],
        bodyEncoding: APIParameterEncoding,
        urlParameters: [String: Any]
    )
}

/// Info for a request.
protocol APIRequestInfo {
    var baseURL: URL { get }
    var path: String { get }
    var task: APITask { get }
    var method: APIMethod { get }
    var headers: [String: String]? { get }
}

protocol APIService {
    func request<Response: Decodable>(info: APIRequestInfo,
                                      completion: @escaping (Result<Response, Error>) -> Void) -> Cancellable
    func requestVoid(info: APIRequestInfo,
                     completion: @escaping (Result<Void, Error>) -> Void) -> Cancellable
}
