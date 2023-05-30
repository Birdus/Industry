//
//  IndustryTests.swift
//  IndustryTests
//
//  Created by  Даниил on 14.05.2023.
//

import XCTest

@testable import Industry
/// Test case for API Manager
class APIMangerTests: XCTestCase {
    
    /// System under test
    var sut: MockAPIManager!
    
    /// Set up for the test case
    override func setUp() {
        super.setUp()
        sut = MockAPIManager()
    }
    
    /// Tear down for the test case
    override func tearDown() {
        sut = nil
        super.tearDown()
    }
    
    /// Test for fetching single item
    func testFetchSingle() {
        let expectation = self.expectation(description: "fetchSingle")
        sut.fetch(request: ForecastType.EmployeeWitchId(id: 2), id: nil, parse: { (json: [String: Any]) -> Int? in
            return json["id"] as? Int
        }, completionHandler: { result in
            switch result {
            case .success(let id):
                XCTAssertEqual(id, 2)
            case .failure(let error):
                XCTFail("Error: \(error)")
            case .successArray(_):
                XCTFail("Expected single object, but got array.")
            }
            expectation.fulfill()
        })
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /// Test for fetching array
    func testFetchArray() {
        let expectation = self.expectation(description: "fetchArray")
        _ = sut.fetch(request: ForecastType.Employee, id: nil, parse: { (json: [[String: Any]]) -> [Int]? in
            return json.compactMap { $0["id"] as? Int }
        }, completionHandler: { (result: APIResult<Int>) in
            switch result {
            case .successArray(let ids):
                XCTAssertEqual(ids, [2, 5, 6])
            case .failure(let error):
                XCTFail("Error: \(error)")
            case .success(_):
                XCTFail("Expected array, but got single object.")
            }
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}


/// Mock API Manager for testing
final class MockAPIManager: APIManager {
    
    var sessionConfiguration: URLSessionConfiguration
    var session: URLSession
    var shouldReturnError = false
    var fetchSingleResponse: Int = 2
    var fetchArrayResponse: [Int] = [2, 5, 6]

    init() {
        self.sessionConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: self.sessionConfiguration)
    }

    func fetch<T: Decodable>(request: ForecastType, parse: @escaping ([[String: Any]]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let task = JSONTaskWithArray(request: request.testRequest, HTTPMethod: .get) { (json, response, error, method) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let json = json as? [[String: Any]], let result = parse(json) {
                completionHandler(.successArray(result))
            }
        }
        task.resume()
    }

    
    func JSONTaskWith(request: URLRequest, HTTPMethod: HttpMethodsString, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            if self.shouldReturnError {
                let error = NSError(domain: "Error", code: 1, userInfo: nil)
                completionHandler(nil, nil, error, nil)
            } else {
                let json: [String: Any] = ["id": self.fetchSingleResponse]
                completionHandler(json, nil, nil, nil)
            }
        }
        return task
    }
    
    func JSONTaskWithArray(request: URLRequest, HTTPMethod: HttpMethodsString, completionHandler: @escaping JSONCompletionHandlerArray) -> JSONTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            if self.shouldReturnError {
                let error = NSError(domain: "Error", code: 1, userInfo: nil)
                completionHandler(nil, nil, error, nil)
            } else {
                let json: [[String: Any]] = self.fetchArrayResponse.map { ["id": $0] }
                completionHandler(json, nil, nil, nil)
            }
        }
        return task
    }

    func fetch<T: Decodable>(request: ForecastType, id: Int?, parse: @escaping ([String: Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let task = JSONTaskWith(request: request.testRequest, HTTPMethod: .get) { (json, response, error, method) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let json = json, let result = parse(json) {
                completionHandler(.success(result))
            }
        }
        task.resume()
    }

    func fetch<T: Decodable>(request: ForecastType, id: Int?, parse: @escaping ([[String: Any]]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void) -> JSONTask {
        let task = JSONTaskWithArray(request: request.testRequest, HTTPMethod: .get) { (json, response, error, method) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let json = json?.compactMap({ $0 }), let result = parse(json) {
                completionHandler(.successArray(result))
            }
        }
        task.resume()
        return task
    }
}
