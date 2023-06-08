//
// AssignmentModelTests.swift
// IndustryTests
//
// Created by Даниил on 14.05.2023.
//

import XCTest

@testable import Industry
/// Unit tests for JSON model decoding
class JSONModelTests: XCTestCase {
    /// Date formatter for the tests
    var dateFormatter: DateFormatter!
    /// Set up for the test case
    override func setUp() {
        super.setUp()
        dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
    }
    /// Tear down for the test case
    override func tearDown() {
        dateFormatter = nil
        super.tearDown()
    }
    
    func testLaborCostDecodeJSON() {
        // given
        let json: [String: Any] = [
            "id": 1,
            "date": "2023-01-10T09:30:00",
            "employeeId": 1,
            "issueId": 1,
            "hourCount": 2
        ]
        
        let expectedLaborCost = LaborCost(id: 1, date: dateFormatter.date(from: "2023-01-10T09:30:00")!, employeeId: 1, issueId: 1, hourCount: 2)
        // when
        let laborCost = LaborCost.decodeJSON(json: json)
        // then
        XCTAssertEqual(laborCost, expectedLaborCost)
        
    }
    
    func testDivisionDecodeJSON() {
        // given
        let json: [String: Any] = [
            "id": 1,
            "divisionName": "Альфа",
        ]
        let expectedDivision = Division(id: 1, divisionName: "Альфа")
        // when
        let division = Division.decodeJSON(json: json)
        // then
        XCTAssertEqual(division, expectedDivision)
    }
    
    func testEmployeeDecodeJSON() {
        // given
        let json: [String: Any] =
        [
            "id": 1,
            "firstName": "Daniil",
            "secondName": "Vinokurov",
            "password": "qwerty",
            "role": "Admin",
            "divisionId": 1,
            "lastName": "Antonovic",
            "serviceNumber": 23232,
            "oneCPass": 123131,
            "post": "Glav",
            "iconPath" : "ddd",
            "division": [
                "id": 4,
                "divisionName": "Продажи",
                "employees": []
            ],
            "laborCosts": []
        ]
        
        let devision = Division(id: 4, divisionName: "Продажи")
        
        
        let expectedEmployee = Employee(id: 1, firstName: "Daniil", secondName: "Vinokurov", password: "qwerty", role: "Admin", divisionId: 1, lastName: "Antonovic", serviceNumber: 23232, oneCPass: 123131, post: "Glav", iconPath: "ddd", division: devision, laborCosts: [])
        
        // when
        let employee = Employee.decodeJSON(json: json)
        
        // then
        XCTAssertEqual(employee, expectedEmployee)
    }

    
    func testProjectDecodeJSON() {
        // given
        let json: [String: Any] = [
            "id": 1,
            "projectName": "Альфа",
        ]
        let expectedProject = Project(id: 1, projectName: "Альфа")
        // when
        let project = Project.decodeJSON(json: json)
        // then
        XCTAssertEqual(project, expectedProject)
    }
    
    func testIssuesDecodeJSON() {
        // given
        let json: [String: Any] = [
            "id": 1,
            "taskName": "Фикс",
            "projectId": 2,
            "taskDiscribe": "Исправить баг",
        ]
        let expectedIssues = Issues(id: 1, taskName: "Фикс", projectId: 2, taskDiscribe: "Исправить баг")
        // when
        let issues = Issues.decodeJSON(json: json)
        // then
        XCTAssertEqual(issues, expectedIssues)
    }
}
