//
//  LaborCostModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation

struct LaborCost: Codable, JSONDecodable {
    let id: Int
    let date: Date
    let employeeId: Int
    let assignmentId: Int
    let hourCount: Int
    let employee: Employee
    let assignment: Assignment
    
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard let id = json["id"] as? Int,
              let dateString = json["date"] as? String,
              let employeeId = json["employeeId"] as? Int,
              let assignmentId = json["assignmentId"] as? Int,
              let hourCount = json["hourCount"] as? Int,
              let employeeJson = json["employee"] as? [String: Any],
              let assignmentJson = json["assignment"] as? [String: Any] else {
            return nil
        }
        
        guard let date = ISO8601DateFormatter().date(from: dateString),
              let employee = Employee.decodeJSON(json: employeeJson),
              let assignment = Assignment.decodeJSON(json: assignmentJson) else {
            return nil
        }
        
        return LaborCost(id: id, date: date, employeeId: employeeId, assignmentId: assignmentId, hourCount: hourCount, employee: employee, assignment: assignment)
    }
}
