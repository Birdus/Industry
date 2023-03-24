//
//  ForecastType.swift
//  Industry
//
//  Created by Birdus on 24.03.2023.
//

import Foundation

enum ForecastType: FinalURLPoint {
    
    case Assignment
    case AssignmentWithId(id: Int)
    case Division
    case DivisionWitchId(id: Int)
    case Employee
    case EmployeeWitchId(id: Int)
    case Project
    case ProjectWitchId(id: Int)
    case LaborCost
    case LaborCostWitchId(id: Int)
    
    
    var baseURL: URL {
        return URL(string: "https://localhost:7229/api")!
    }
    
    var path: String {
        switch self {
        case .Assignment:
            return "/Assignment"
        case .AssignmentWithId(let id):
            return "/Assignment/\(id)"
        case .Division:
            return "/Division"
        case .DivisionWitchId(let id):
            return "/Division/\(id)"
        case .Employee:
            return "/Employee"
        case .EmployeeWitchId(let id):
            return "/Employee/\(id)"
        case .Project:
            return "/Project"
        case .ProjectWitchId(let id):
            return "/Project/\(id)"
        case .LaborCost:
            return "/LaborCost/"
        case .LaborCostWitchId(id: let id):
            return "/LaborCost/\(id)"
            
        }
    }
    
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}
