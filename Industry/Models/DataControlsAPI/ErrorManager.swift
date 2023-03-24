//
//  ErrorManager.swift
//  Industry
//
//  Created by Birdus on 22.03.2023.
//
import Foundation

enum INDNetworkingError: Error {
    case missingHTTPResponse
    case serverError
    case badRequest
    case notFound
    case unexpectedResponse(message: String)
    
    static let errorDomain = "Industry.NetworkingError"
    
    var errorCode: Int {
        switch self {
        case .missingHTTPResponse:
            return 100
        case .serverError:
            return 500
        case .badRequest:
            return 400
        case .notFound:
            return 404
        case .unexpectedResponse:
            return 200
        }
    }
    
    var errorMessage: String {
        switch self {
        case .missingHTTPResponse:
            return "Missing HTTP response"
        case .serverError:
            return "Server error"
        case .badRequest:
            return "Bad request"
        case .notFound:
            return "Not found"
        case .unexpectedResponse(let message):
            return "Unexpected response: \(message)"
        }
    }
    
    init(statusCode: Int?, message: String? = nil) {
        switch statusCode {
        case 400:
            self = .badRequest
        case 404:
            self = .notFound
        case 500:
            self = .serverError
        default:
            if let message = message {
                self = .unexpectedResponse(message: message)
            } else {
                self = .missingHTTPResponse
            }
        }
    }
}


