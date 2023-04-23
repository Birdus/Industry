//
//  HttpMetods.swift
//  Industry
//
//  Created by Birdus on 24.03.2023.
//

import Foundation

// MARK: - HttpMethodsString
/// HttpMethodsString represents HTTP methods in string format.
enum HttpMethodsString {
    /// HTTP GET method.
    case get
    
    /// HTTP POST method.
    case post
    
    /// HTTP PUT method.
    case put
    
    /// HTTP DELETE method.
    case delete
    
    /// Returns the corresponding string value for the HTTP method.
    var stringValue: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}
