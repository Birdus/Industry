//
//  ForecastType.swift
//  Industry
//
//  Created by Birdus on 24.03.2023.
//

import Foundation
import UIKit

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
    /// Endpoint for obtaining a token with the provided credentials.
    case Token(credentials: AuthBody)
    /// Endpoint for resetting a password.
    case ResetPassword
    /// Endpoint for confirming the reset of a password.
    case ConfirmResetPassword
    /// Endpoint for checking the validity of a confirmation code.
    case CheakValidConfirmationCode
    /// Endpoint for loading an image from a specific URL.
    case LoadImage
    /// Endpoint for uploading an image from a specific URL.
    case UploadImage(id: Int)
    
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
            return "Divisions"
        case .DivisionWitchId(let id):
            return "Divisions/\(id)"
        case .Employee:
            return "Employees"
        case .EmployeeWitchId(let id):
            return "Employees/\(id)"
        case .Project:
            return "Projects"
        case .ProjectWitchId(let id):
            return "Projects/\(id)"
        case .LaborCost:
            return "LaborCosts/"
        case .LaborCostWitchId(id: let id):
            return "LaborCosts/\(id)"
        case .Token:
            return "Auth/token"
        case .ResetPassword:
            return "Auth/reset-password"
        case .ConfirmResetPassword:
            return "Auth/confirm-reset-password"
        case .CheakValidConfirmationCode:
            return "Auth/cheak-valid-confirmation-code"
        case .LoadImage:
            return "Employees/GetImage"
        case .UploadImage(let id):
            return "Employees/\(id)"
        }
    }
    
    func createURLRequest(withToken: Bool = false) -> URLRequest {
        let url = URL(string: path, relativeTo: baseURL)!
        var urlRequest = URLRequest(url: url)
        if let identifier = UIDevice.current.identifierForVendor?.uuidString {
            urlRequest.setValue(identifier, forHTTPHeaderField: "DeviceCode")
        }
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if withToken {
            guard let accessToken = self.getAccessToken() else {
                return urlRequest
            }
            urlRequest.setValue("Bearer \(accessToken.token)", forHTTPHeaderField: "Authorization")
            if case .Token(let credentials) = self {
                urlRequest.httpMethod = "POST"
                do {
                    let jsonData = try JSONEncoder().encode(credentials)
                    urlRequest.httpBody = jsonData
                } catch {
                    fatalError("Encoding credentials failed.")
                }
            }
        }
        return urlRequest
    }

    /// The URL request with authorization JWT token for the endpoint.
    var requestWitchToken: URLRequest {
        return createURLRequest(withToken: true)
    }

    /// The URL reques  for the endpoint.
    var requestWitchOutToken: URLRequest {
        return createURLRequest()
    }
    
    /// This Bool check is needed to verify if a token is required in the reques
    var isTokenRequired: Bool {
        switch self {
        case .ResetPassword, .ConfirmResetPassword, .Token, .CheakValidConfirmationCode:
            return false
        default:
            return true
        }
    }
    
    /// This URL end point.
    var absoluteURL: URL {
        return URL(string: "\(self.baseURL) + \(self.path)")!
    }
    
    /// This URL dont work, this URL need to unit test
    var testRequest: URLRequest {
        let url = URL(string: path, relativeTo: testBaseURL)
        return URLRequest(url: url!)
    }
}

extension ForecastType: KeychainWorkerProtocol {
    static var KEY_ACCESS_TOKEN_NBF: String = "key_access_token_nbf"
    static var KEY_AUTH_BODY_EMAIL: String = "key_auth_body_email"
    static var KEY_AUTH_BODY_PASSWORD: String = "key_auth_body_password"
    static let KEY_ACCESS_TOKEN = "auth_token"
    static let KEY_ACCESS_TOKEN_EXPIRE = "auth_token_expire"
    static let ACCESS_TOKEN_LIFE_THRESHOLD_SECONDS: Int64 = 3600
}
