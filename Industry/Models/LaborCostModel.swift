//
//  LaborCostModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation

struct LaborCost: Codable {
    let id: Int
    let date: Date
    let employeeId: Int
    let assignmentId: Int
    let hourCount: Int
    let employee: Employee
    let assignment: Assignment
}
