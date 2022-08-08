//
//  APIServiceTest.swift
//  iOS-Architecture-MVVMCTests
//
//  Created by datlt on 27/05/2022.
//

import XCTest

class APIServiceTest: XCTestCase {
    enum TestAPI: APIRequestInfo {
        case requestGetMethod
        case requestPostMethod
        case successWithErrorResponse
        case successWithResponse
        case failureWithResonse

        var baseURL: URL {
            return URL(string: "https://test-api.free.beeceptor.com")!
        }

        var path: String {
            switch self {
            case .requestGetMethod:
                return "/test_data"
            case .requestPostMethod:
                return "/test_data_post"
            case .successWithErrorResponse:
                return "/success_with_error_response"
            case .successWithResponse:
                return "/success_with_response"
            case .failureWithResonse:
                return "/failure_with_response"
            }
        }

        var task: APITask {
            return .requestPlain
        }

        var method: APIMethod {
            switch self {
            case .requestGetMethod:
                return .GET
            case .requestPostMethod,
                    .successWithErrorResponse,
                    .successWithResponse,
                    .failureWithResonse:
                return .POST
            }
        }

        var headers: [String : String]? {
            return nil
        }
    }
    
    struct Message: Decodable {
        let id: Int
        let message: String
    }

    struct ErrorData: Decodable, Error {
        let id: Int
        let message: String
    }

    struct ErrorResponse: Decodable, Error {
        let statusCode: Int
        let data: ErrorData
    }

    lazy var apiService: APIService = MoyaAPIService()

    // MARK: - Example
    func testRequestGetMethod() throws {
        let expectation = XCTestExpectation(description: "perform API request")

        _ = apiService.request(info: TestAPI.requestGetMethod, completion: { (result: Result<String, Error>) in
            switch result {
            case .success(let helloWorldMessage):
                print(helloWorldMessage)
            case .failure(_):
                print("failed")
            }

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
    }

    func testRequestPostMethod() {
        let expectation = XCTestExpectation(description: "perform API request")

        _ = apiService.request(info: TestAPI.requestPostMethod, completion: { (result: Result<Message, Error>) in
            switch result {
            case .success(let message):
                print(message)
            case .failure(_):
                print("failed")
            }

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
    }

    func testErrorResponseStatusSuccess() {
        let expectation = XCTestExpectation(description: "perform API request")

        _ = apiService.request(info: TestAPI.successWithErrorResponse,
                               errorResponseType: ErrorResponse.self,
                               completion: { (result: Result<DataResponse<Message>, Error>) in
            switch result {
            case .success(let message):
                print(message)
            case .failure(let error):
                if let error = error as? ErrorResponse {
                    print("error status code: \(error.statusCode)")
                    print("error message: \(error.data.message)")
                } else {
                    print(error)
                }
            }

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
    }

    func testResponseStatusSuccess() {
        let expectation = XCTestExpectation(description: "perform API request")

        _ = apiService.request(info: TestAPI.successWithResponse,
                               errorResponseType: ErrorResponse.self,
                               completion: { (result: Result<DataResponse<Message>, Error>) in
            switch result {
            case .success(let response):
                print("message: \(response.data?.message ?? "")")
            case .failure(let error):
                if let error = error as? ErrorResponse {
                    print("error status code: \(error.statusCode)")
                    print("error message: \(error.data.message)")
                } else {
                    print(error)
                }
            }

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
    }
    
    func testFailureWithResponse() {
        let expectation = XCTestExpectation(description: "perform API request")

        _ = apiService.request(info: TestAPI.failureWithResonse,
                               errorResponseType: ErrorResponse.self,
                               completion: { (result: Result<DataResponse<Message>, Error>) in
            switch result {
            case .success(let response):
                print("message: \(response.data?.message ?? "")")
            case .failure(let error):
                if let error = error as? ErrorResponse {
                    print("error status code: \(error.statusCode)")
                    print("error message: \(error.data.message)")
                } else {
                    print(error)
                }
            }

            expectation.fulfill()
        })

        wait(for: [expectation], timeout: 10.0)
    }
}
