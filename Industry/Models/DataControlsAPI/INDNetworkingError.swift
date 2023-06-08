// MARK: - ErrorManager

/// ErrorManager handles networking errors in the Industry app.
enum INDNetworkingError: Error {
    /// The HTTP response is missing.
    case missingHTTPResponse
    /// A server error occurred.
    case serverError
    /// A bad request was made.
    case badRequest
    /// The requested resource was not found.
    case notFound
    /// An unexpected response was received.
    case unexpectedResponse(message: String)
    
    case encodingFailed
    
    case decodingFailed
    
    case invalidAccessToken
    
    static let errorDomain = "Industry.NetworkingError"
    
    /// Returns the corresponding error code for the error.
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
            return 600 
        case .encodingFailed:
            return 606
        case .decodingFailed:
            return 607
        case .invalidAccessToken:
            return 700
        }
    }
    
    /// Returns the corresponding error message for the error.
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
        case .encodingFailed:
            return "Encoding Failed"
        case .decodingFailed:
            return "Decoding Failed"
        case .invalidAccessToken:
            return "Invalid Access Token"
        }
    }
    
    /// Initializes an error with a given HTTP status code and optional message.
    init(statusCode: Int?, message: String? = nil) {
        switch statusCode {
        case 100:
            self = .missingHTTPResponse
        case 500:
            self = .serverError
        case 400:
            self = .badRequest
        case 404:
            self = .notFound
        case 606:
            self = .encodingFailed
        case 607:
            self = .decodingFailed
        case 700:
            self = .invalidAccessToken
        default:
            if let message = message {
                self = .unexpectedResponse(message: message)
            } else {
                self = .missingHTTPResponse
            }
        }
    }
}
