//
//  ForecastType.swift
//  Industry
//
//  Created by Birdus on 24.03.2023.
//

import Foundation

// MARK: - ForecastType
/**
 ForecastType represents the available API endpoints for Industry app's forecast feature.
 Each case in the enum corresponds to a specific endpoint.
 */
enum ForecastType: FinalURLPoint {
    /// Endpoint for getting a list of assignments.
    case Issue
    /// Endpoint for getting a specific assignment by ID.
    case IssueWithId(id: Int)
    /// Endpoint for getting a list of divisions.
    case Division
    /// Endpoint for getting a specific division by ID.
    case DivisionWitchId(id: Int)
    /// Endpoint for getting a list of employees.
    case Employee
    /// Endpoint for getting a specific employee by ID.
    case EmployeeWitchId(id: Int)
    /// Endpoint for getting a list of projects.
    case Project
    /// Endpoint for getting a specific project by ID.
    case ProjectWitchId(id: Int)
    /// Endpoint for getting a list of labor costs.
    case LaborCost
    /// Endpoint for getting a specific labor cost by ID.
    case LaborCostWitchId(id: Int)
    
    
    
    /// The base URL for all endpoints.
    var baseURL: URL {
        return URL(string: "http://80.78.253.153/api/")!
    }
    
    /// This URL dont work, this URL need to unit test
    var testBaseURL: URL {
        return URL(string: "http://example/api/")!
    }
    
    /// The path for the endpoint.
    var path: String {
        switch self {
        case .Issue:
            return "Issues"
        case .IssueWithId(let id):
            return "Issues/\(id)"
        case .Division:
            return "Division"
        case .DivisionWitchId(let id):
            return "Division/\(id)"
        case .Employee:
            return "Employees"
        case .EmployeeWitchId(let id):
            return "Employees/\(id)"
        case .Project:
            return "Project"
        case .ProjectWitchId(let id):
            return "Project/\(id)"
        case .LaborCost:
            return "LaborCost/"
        case .LaborCostWitchId(id: let id):
            return "LaborCost/\(id)"
            
        }
    }
    
    /// The URL request for the endpoint.
    var request: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
    
    /// This URL dont work, this URL need to unit test
    var testRequest: URLRequest {
        let url = URL(string: path, relativeTo: baseURL)
        return URLRequest(url: url!)
    }
}
