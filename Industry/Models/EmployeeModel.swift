//
//  EmployeeModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation

struct Employee: Codable {
    let id: Int
    let firstName: String
    let secondName: String
    let password: String
    let role: String
    let divisionId: Int
    let lastName: String
    let serviceNumber: Int
    let oneCPass: Int
    let post: String
    let division: Division
    let laborCosts: [LaborCost]
}
