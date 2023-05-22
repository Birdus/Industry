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
        
        sut.fetch(request: ForecastType.EmployeeWitchId(id: 2), HTTPMethod: .get) { (json: [String: Any]) -> Int? in
            return json["id"] as? Int
        } completionHandler: { result in
            switch result {
            case .success(let id):
                XCTAssertEqual(id, 2)
            case .failure(let error):
                XCTFail("Error: \(error)")
            case .successArray(_):
                XCTFail("Expected single object, but got array.")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    /// Test for fetching array
    func testFetchArray() {
        sut.fetch(request: ForecastType.Employee, HTTPMethod: .get) { (json: [String: Any]) -> [Int]? in
            return json["id"] as? [Int]
        } completionHandler: { (result: APIResult<Int>) in
            switch result {
            case .successArray(let ids):
                XCTAssertEqual(ids, [2, 5, 6])
            case .failure(let error):
                XCTFail("Error: \(error)")
            case .success(_):
                XCTFail("Expected array, but got single object.")
            }
        }
    }
    
}


/// Mock API Manager for testing
final class MockAPIManager: APIManager {
    
    
    
    /// Session configuration for the manager
    var sessionConfiguration: URLSessionConfiguration
    /// Session for the manager
    var session: URLSession
    /// Flag to determine if error should be returned
    var shouldReturnError = false
    /// Response to be returned for single fetch
    var fetchSingleResponse: Int = 2
    /// Response to be returned for array fetch
    var fetchArrayResponse: [Int] = [2, 5, 6]
    
    /// Initialize the mock API manager
    init() {
        self.sessionConfiguration = URLSessionConfiguration.default
        self.session = URLSession(configuration: self.sessionConfiguration)
    }
    
    /// Task for JSON
    func JSONTaskWith(request: URLRequest, HTTPMethod: HttpMethodsString, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        let task = session.dataTask(with: request) { (data, response, error) in
            if self.shouldReturnError {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error: JSON empty").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                completionHandler(nil, nil, error, nil)
            } else {
                let json: [String: Any]
                if HTTPMethod == .get {
                    json = ["id": self.fetchSingleResponse]
                } else {
                    json = ["id": self.fetchArrayResponse]
                }
                completionHandler(json, nil, nil, nil)
            }
        }
        return task
    }
    
    /// Fetch single item
    func fetch<T: Decodable>(request: ForecastType, HTTPMethod: HttpMethodsString, parse: @escaping ([String: Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let task = JSONTaskWith(request: request.testRequest, HTTPMethod: HTTPMethod) { (json, response, error, method) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let json = json, let result = parse(json) {
                completionHandler(.success(result))
            }
        }
        task.resume()
    }
    
    /// Fetch array of items
    func fetch<T: Decodable>(request: ForecastType, HTTPMethod: HttpMethodsString, parse: @escaping ([String: Any]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let task = JSONTaskWith(request: request.testRequest, HTTPMethod: HTTPMethod) { (json, response, error, method) in
            if let error = error {
                completionHandler(.failure(error))
            } else if let json = json, let result = parse(json) {
                completionHandler(.successArray(result))
            }
        }
        task.resume()
    }
    
    func deleteItem(request: ForecastType, completionHandler: @escaping (APIResult<Void>) -> Void) {
        return
    }
}

