//import XCTest
//@testable import Industry
//
//class APIManagerIndustryTests: XCTestCase {
//    
//    var apiManager: APIManagerIndustry!
//    let sessionConfiguration = URLSessionConfiguration.default
//    
//    override func setUp() {
//        super.setUp()
//        apiManager = APIManagerIndustry(sessionConfiguration: sessionConfiguration)
//    }
//    
//    func testFetch_WithValidRequest_ReturnsData() {
//        // given
//        let url = URL(string: "https://example.com")!
//        let request = URLRequest(url: url)
//        let expectation = XCTestExpectation(description: "fetch() should return data")
//        
//        // when
//        apiManager.fetch(request: request, HTTPMethod: .get, parse: { _ in return nil }) { (result: APIResult<[String]>) in
//            switch result {
//            case .success:
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("fetch() should not fail with error: \(error.localizedDescription)")
//            case .successArray(_):
//                expectation.fulfill()
//            }
//        }
//        
//        // then
//        wait(for: [expectation], timeout: 10.0)
//    }
//    
//    func testFetch_WithInvalidRequest_ReturnsError() {
//        // given
//        let url = URL(string: "https://invalid-url.com")!
//        let request = URLRequest(url: url)
//        let expectation = XCTestExpectation(description: "fetch() should fail with error")
//        
//        // when
//        apiManager.fetch(request: request, HTTPMethod: .get, parse: { _ in return nil }) { (result: APIResult<[String]>) in
//            switch result {
//            case .success:
//                XCTFail("fetch() should fail with error")
//            case .failure:
//                expectation.fulfill()
//            case .successArray(_):
//                XCTFail("fetch() should fail with error")
//            }
//        }
//        
//        // then
//        wait(for: [expectation], timeout: 10.0)
//    }
//    
//    func testFetch_WithValidRequestAndValidResponseData_ReturnsParsedData() {
//        // given
//        let url = URL(string: "https://example.com")!
//        let request = URLRequest(url: url)
//        let json: [String: Any] = ["key": "value"]
//        let expectation = XCTestExpectation(description: "fetch() should return parsed data")
//        
//        // when
//        apiManager.fetch(request: request, HTTPMethod: .get, 1, parse: { _ in return json }) { result in
//            switch result {
//            case .success(let data):
//                XCTAssertNotNil(data)
//                expectation.fulfill()
//            case .failure(let error):
//                XCTFail("fetch() should not fail with error: \(error.localizedDescription)")
//            case .successArray(let data):
//                XCTAssertNotNil(data)
//                expectation.fulfill()
//            }
//        }
//        
//        // then
//        wait(for: [expectation], timeout: 10.0)
//    }
//    
//    func testFetch_WithValidRequestAndInvalidResponseData_ReturnsError() {
//        // given
//        let url = URL(string: "https://example.com")!
//        let request = URLRequest(url: url)
//        let json: [String: Any] = ["invalidKey": "invalidValue"]
//        let expectation = XCTestExpectation(description: "fetch() should fail with error")
//        
//        // when
//        apiManager.fetch(request: request, HTTPMethod: .get, 1, parse: { _ in return json }) { result in
//            switch result {
//            case .success:
//                XCTFail("fetch() should fail with error")
//            case .failure:
//                expectation.fulfill()
//            case .successArray(_):
//                XCTFail("fetch() should fail with error")
//            }
//        }
//        
//        // then
//        wait(for: [expectation], timeout: 10.0)
//    }
//    
//}
