//
//  MoyaAPIService.swift
//  iOS-Architecture-MVVMC
//
//  Created by datlt on 23/05/2022.
//

import Alamofire
import Foundation
import Moya

private struct APIRequestInfoAdapter: TargetType {
    let info: APIRequestInfo

    var baseURL: URL { return info.baseURL }

    var path: String { return info.path }

    var method: Moya.Method { return Moya.Method(rawValue: info.method.rawValue) }

    var headers: [String: String]? { return info.headers }

    var validationType: ValidationType { return .successCodes }

    var task: Moya.Task {
        switch info.task {
        case .requestPlain:
            return .requestPlain
        case let .requestData(data):
            return .requestData(data)
        case let .requestJSONEncodable(encodable):
            return .requestJSONEncodable(encodable)
        case let .requestCustomJSONEncodable(encodable, encoder):
            return .requestCustomJSONEncodable(encodable, encoder: encoder)
        case let .requestParameters(parameters, encoding):
            let parameterEncoding: ParameterEncoding = (encoding == .urlEncoding) ? URLEncoding.default : JSONEncoding.default
            return .requestParameters(parameters: parameters, encoding: parameterEncoding)
        case let .requestCompositeData(bodyData, urlParameters):
            return .requestCompositeData(bodyData: bodyData, urlParameters: urlParameters)
        case let .requestCompositeParameters(bodyParameters, bodyEncoding, urlParameters):
            let encoding: ParameterEncoding = (bodyEncoding == .urlEncoding) ? URLEncoding.default : JSONEncoding.default
            return .requestCompositeParameters(
                bodyParameters: bodyParameters,
                bodyEncoding: encoding,
                urlParameters: urlParameters
            )
        }
    }
}

private struct MoyaCancellableAdapter: Cancellable {
    let cancellable: Moya.Cancellable
    func cancel() {
        cancellable.cancel()
    }
}

class MoyaAPIService: APIService {
    private let provider: MoyaProvider<APIRequestInfoAdapter>
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        //decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }

    init(configuration: URLSessionConfiguration? = nil,
         retryCount: UInt = 0,
         refreshTokenInterceptor: RefreshTokenInterceptor? = nil) {
        let callbackQueue = DispatchQueue.global(qos: .utility)
        let sessionConfig = configuration ?? URLSessionConfiguration.default

        let sessionRetrier = RetryPolicy.retryPolicy(retryLimit: retryCount)
        let sessionInterceptor = Interceptor(retriers: [sessionRetrier])

        var authInterceptor: RequestInterceptor?
        if let refreshTokenInterceptor = refreshTokenInterceptor {
            let authenticator = ServiceAuthenticator(refreshTokenInterceptor)
            let credential = ServiceCredential(accessToken: refreshTokenInterceptor.accessToken,
                                               expiration: refreshTokenInterceptor.expiration,
                                               refreshInterval: refreshTokenInterceptor.refreshInterval)
            authInterceptor = AuthenticationInterceptor(authenticator: authenticator,
                                                        credential: credential)
        }

        let requestInterceptors = [authInterceptor, sessionInterceptor].compactMap({ $0 })
        let interceptor = Interceptor(interceptors: requestInterceptors)
        let session = Session(configuration: sessionConfig,
                              startRequestsImmediately: false,
                              interceptor: interceptor)

        provider = MoyaProvider(callbackQueue: callbackQueue,
                                session: session,
                                plugins: [NetworkLoggerPlugin()])
    }

    func request<Response>(info: APIRequestInfo,
                           completion: @escaping (Result<Response, Error>) -> Void) -> Cancellable where Response: Decodable {
        let infoAdapter = APIRequestInfoAdapter(info: info)

        let cancellable = provider.request(infoAdapter) { [weak self] result in
            guard let weakSelf = self else { return }

            switch result {
            case let .success(response):
                let decodedResponseResult = weakSelf.decodeResponse(response, type: Response.self)
                switch decodedResponseResult {
                case let .success(response):
                    DispatchQueue.main.async {
                        completion(.success(response))
                    }
                case let .failure(error):
                    DispatchQueue.main.async {
                        let error = ErrorServiceMapper().map(error)
                        completion(.failure(error))
                    }
                }
            case let .failure(moyaError):
                // TODOs: handle the error if needed
                print("handle the error if needed")
                DispatchQueue.main.async {
                    let error = ErrorServiceMapper().map(moyaError)
                    completion(.failure(error))
                }
            }
        }

        return MoyaCancellableAdapter(cancellable: cancellable)
    }

    func requestVoid(
        info: APIRequestInfo,
        completion: @escaping (Result<Void, Error>) -> Void
    ) -> Cancellable {
        let infoAdapter = APIRequestInfoAdapter(info: info)

        let cancellable = provider.request(infoAdapter) { [weak self] result in
            guard let weakSelf = self else { return }

            switch result {
            case let .success(response):
                do {
                    let responseObject = try response.map(
                        BaseResponse.self,
                        atKeyPath: nil,
                        using: weakSelf.jsonDecoder,
                        failsOnEmptyData: false
                    )
                    if responseObject.success {
                        DispatchQueue.main.async {
                            completion(.success(()))
                        }
                    } else {
                        print("handle the error if needed")
                        let error = ErrorServiceMapper().map(MoyaError.imageMapping(response))
                        completion(.failure(error))
                    }
                } catch let error {
                    guard let moyaError = error as? MoyaError else {
                        fatalError("Imposible case")
                    }
                    let error = ErrorServiceMapper().map(moyaError)
                    completion(.failure(error))
                }

            case let .failure(moyaError):
                DispatchQueue.main.async {
                    let error = ErrorServiceMapper().map(moyaError)
                    completion(.failure(error))
                }
            }
        }
        return MoyaCancellableAdapter(cancellable: cancellable)
    }

    private func decodeResponse<D: Decodable>(_ response: Response,
                                              type: D.Type) -> Result<D, Error> {
        do {
            let decodedResponse = try response.map(
                type,
                atKeyPath: nil,
                using: jsonDecoder,
                failsOnEmptyData: false
            )
            return .success(decodedResponse)
        } catch let error {
            return .failure(error)
        }
    }
}

// MARK: - AuthenticationCredential

private struct ServiceCredential: AuthenticationCredential {
    let accessToken: String
    let expiration: Date?
    /// The duration(in second) before expiration.
    let refreshInterval: Double?

    var requiresRefresh: Bool {
        if let refreshInterval = refreshInterval, let expiration = expiration {
            // Require refresh if within refreshInterval of expiration
            return Date(timeIntervalSinceNow: refreshInterval) > expiration
        }

        return false
    }
}

// MARK: - Authenticator

private class ServiceAuthenticator: Authenticator {
    typealias Credential = ServiceCredential

    private let refreshTokenInterceptor: RefreshTokenInterceptor

    init(_ refreshTokenInterceptor: RefreshTokenInterceptor) {
        self.refreshTokenInterceptor = refreshTokenInterceptor
    }

    func apply(_ credential: ServiceCredential, to urlRequest: inout URLRequest) {
        urlRequest.headers.add(.authorization(bearerToken: credential.accessToken))
    }

    func refresh(_ credential: ServiceCredential,
                 for session: Session,
                 completion: @escaping (Result<ServiceCredential, Error>) -> Void) {
        refreshTokenInterceptor.refresh(completion: { [weak self] result in
            guard let weakSelf = self else { return }

            switch result {
            case let .success(accessToken):
                let expiration = weakSelf.refreshTokenInterceptor.expiration
                let refreshInterval = weakSelf.refreshTokenInterceptor.refreshInterval
                completion(.success(ServiceCredential(accessToken: accessToken,
                                                      expiration: expiration,
                                                      refreshInterval: refreshInterval)))
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }

    func didRequest(_ urlRequest: URLRequest,
                    with response: HTTPURLResponse,
                    failDueToAuthenticationError error: Error) -> Bool {
        return response.statusCode == refreshTokenInterceptor.unauthorizedCode
    }

    func isRequest(_ urlRequest: URLRequest, authenticatedWith credential: ServiceCredential) -> Bool {
        let bearerToken = HTTPHeader.authorization(bearerToken: credential.accessToken).value
        return urlRequest.headers["Authorization"] == bearerToken
    }
}
