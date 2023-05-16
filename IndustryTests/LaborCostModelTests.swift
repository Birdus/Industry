import XCTest
@testable import Industry

class LaborCostModelTests: XCTestCase {

    func testDecodeJSON_WithValidJSON_ReturnsValidModel() {
        // Given
        let json: [String: Any] = [
            "id": 1,
            "date": "2022-01-01T00:00:00Z",
            "employeeId": 2,
            "assignmentId": 3,
            "hourCount": 4,
            "employee": [
                "id": 2,
                "firstName": "John Doe"
            ],
            "assignment": [
                "id": 3,
                "taskName": "Task",
                "projectId": 4,
                "taskDiscribe": "Task description",
                "project": [
                    "id": 4,
                    "projectName": "Project"
                ],
                "laborCosts": []
            ]
        ]
        
        // When
        let laborCost = LaborCost.decodeJSON(json: json)
        
        // Then
        XCTAssertNotNil(laborCost)
        XCTAssertEqual(laborCost?.id, 1)
        XCTAssertEqual(laborCost?.employeeId, 2)
        XCTAssertEqual(laborCost?.assignmentId, 3)
        XCTAssertEqual(laborCost?.hourCount, 4)
        XCTAssertEqual(laborCost?.employee.id, 2)
        XCTAssertEqual(laborCost?.employee.firstName, "John Doe")
        XCTAssertEqual(laborCost?.assignment.id, 3)
        XCTAssertEqual(laborCost?.assignment.taskName, "Task")
        XCTAssertEqual(laborCost?.assignment.projectId, 4)
        XCTAssertEqual(laborCost?.assignment.taskDiscribe, "Task description")
        XCTAssertEqual(laborCost?.assignment.project.id, 4)
        XCTAssertEqual(laborCost?.assignment.project.projectName, "Project")
        XCTAssertEqual(laborCost?.assignment.laborCosts.count, 0)
    }
    
    func testDecodeJSON_WithInvalidJSON_ReturnsNil() {
        // Given
        let json: [String: Any] = [:]
        
        // When
        let laborCost = LaborCost.decodeJSON(json: json)
        
        // Then
        XCTAssertNil(laborCost)
    }
}
