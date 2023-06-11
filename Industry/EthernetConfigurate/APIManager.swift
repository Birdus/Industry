//
//  APIManager.swift
//  Industry
//
//  Created by Birdus on 23.03.2023.
//

import Foundation
import KeychainSwift
import JWTDecode

// MARK: - APIManagerIndustry

/**
 The APIManagerIndustry class is responsible for making network requests and parsing responses for the Industry app.
 */
final class APIManagerIndustry: APIManager {
    
    private var accessToken: TokenInfo?
    private var refreshToken: TokenInfo?
    
    /**
     Makes a network request to fetch an array of objects that conform to `JSONDecodable`.
     - Parameters:
        -  request The `URLRequest` object that defines the network request to be made.
        -  HTTPMethod The HTTP method used to make the request.
        -  parse: A closure that takes a dictionary of `[String: Any]` as input and returns an array of objects that conform to `JSONDecodable`.
        -  completionHandler: A closure that takes an `APIResult` object as input and has no return value.
     */
    func fetch<T>(request: ForecastType, parse: @escaping ([[String: Any]]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void) where T: Decodable {
        refreshTokens { result in
            if case .failure(let error) = result {
                completionHandler(.failure(error))
                return
            }
        }
        
        var requestToFetch = request.requestWitchToken
        requestToFetch.httpMethod = HttpMethodsString.get.stringValue
        let dataTask = JSONTaskWithArray(request: requestToFetch, HTTPMethod: HttpMethodsString.get) { (json, response, error, _) in
            
            guard let HTTPResponse = response else {
                let error = INDNetworkingError.missingHTTPResponse
                return completionHandler(.failure(error))
            }

            let responseError = INDNetworkingError(statusCode: HTTPResponse.statusCode, message: error?.localizedDescription)

            if !(200...299).contains(HTTPResponse.statusCode) {
                return completionHandler(.failure(responseError))
            }

            guard let json = json else {
                let error = INDNetworkingError.unexpectedResponse(message: "Unexpected error: no JSON response")
                return completionHandler(.failure(error))
            }
            
            let compactedJSON = json.compactMap { $0 }
            guard let items = parse(compactedJSON) else {
                let error = INDNetworkingError.unexpectedResponse(message: "Error parsing JSON")
                return completionHandler(.failure(error))
            }
            completionHandler(.successArray(items))
        }
        dataTask.resume()
    }

    
    /**
     Makes a network request to fetch a single object that conforms to `JSONDecodable`.
     - Parameters:
        - request: The `URLRequest` object that defines the network request to be made.
        - HTTPMethod: The HTTP method used to make the request.
        - id: An optional `Int` value that represents the ID of the object to be fetched.
        - parse: A closure that takes a dictionary of `[String: Any]` as input and returns an object that conforms to `JSONDecodable`.
        - completionHandler: A closure that takes an `APIResult` object as input and has no return value.
     */
    func fetch<T>(request: ForecastType, parse: @escaping ([String : Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) where T : Decodable {
        refreshTokens { result in
            if case .failure(let error) = result {
                completionHandler(.failure(error))
                return
            }
        }
        var requestToFetch = request.requestWitchToken
        requestToFetch.httpMethod = HttpMethodsString.get.stringValue
        let task = JSONTaskWith(request: requestToFetch, HTTPMethod: HttpMethodsString.get) { (json, response, error, _) in
            
            if let error = error {
                return completionHandler(.failure(INDNetworkingError.init(statusCode: (response)?.statusCode, message: error.localizedDescription)))
            }
            
            guard let HTTPResponse = response else {
                let error = INDNetworkingError.missingHTTPResponse
                return completionHandler(.failure(error))
            }
            
            let responseError = INDNetworkingError(statusCode: HTTPResponse.statusCode, message: error?.localizedDescription)

            if !(200...299).contains(HTTPResponse.statusCode) {
                return completionHandler(.failure(responseError))
            }
            
            guard let json = json else {
                let error = INDNetworkingError.unexpectedResponse(message: "Unexpected error: no JSON response")
                return completionHandler(.failure(error))
            }
            
            guard let item = parse(json) else {
                let error = INDNetworkingError.unexpectedResponse(message: "Error parsing JSON")
                return completionHandler(.failure(error))
            }
            completionHandler(.success(item))
        }
        task.resume()
    }
    
    func put<T>(request: ForecastType, data: T, completionHandler: @escaping (APIResult<Int>) -> Void) where T : Encodable {
        refreshTokens { result in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
                return
            case .success:
                break
            }
        }
        var requestToPut = request.requestWitchToken
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(data) else {
            let error = INDNetworkingError.encodingFailed
            completionHandler(.failure(error))
            return
        }
        requestToPut.httpMethod = HttpMethodsString.put.stringValue
        requestToPut.httpBody = data
        let task = JSONTaskWith(request: requestToPut, HTTPMethod: HttpMethodsString.put) { (json, response, error, _) in
            if let error = error {
                completionHandler(.failure(INDNetworkingError.init(statusCode: (response)?.statusCode, message: error.localizedDescription)))
                return
            }
            guard let HTTPResponse = response else {
                let error = INDNetworkingError.missingHTTPResponse
                return completionHandler(.failure(error))
            }
            let responseError = INDNetworkingError(statusCode: HTTPResponse.statusCode, message: error?.localizedDescription)

            if !(200...299).contains(HTTPResponse.statusCode) {
                return completionHandler(.failure(responseError))
            }
            
            completionHandler(.success(HTTPResponse.statusCode))
        }
        task.resume()
    }
    
    func post<T>(request: ForecastType, data: T, completionHandler: @escaping (APIResult<Int>) -> Void) where T : Encodable {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(data) else {
            let error = INDNetworkingError.encodingFailed
            completionHandler(.failure(error))
            return
        }
        var requestToPost = request.isTokenRequired ? request.requestWitchToken : request.requestWitchOutToken
        requestToPost.httpMethod = HttpMethodsString.post.stringValue
        requestToPost.httpBody = data
        let launchTask = {
            let task = self.JSONTaskWith(request: requestToPost, HTTPMethod: HttpMethodsString.post) { (json, response, error, _) in
                if let error = error {
                    let errorUser = INDNetworkingError.init(error)
                    completionHandler(.failure(errorUser))
                    return
                }
                guard let HTTPResponse = response else {
                    let error = INDNetworkingError.missingHTTPResponse
                    return completionHandler(.failure(error))
                }
                let responseError = INDNetworkingError(statusCode: HTTPResponse.statusCode, message: error?.localizedDescription)

                if !(200...299).contains(HTTPResponse.statusCode) {
                    return completionHandler(.failure(responseError))
                }
                
                if HTTPResponse.statusCode == 201,
                   let locationHeader = HTTPResponse.allHeaderFields["Location"] as? String,
                   let url = URL(string: locationHeader),
                   let id = Int(url.lastPathComponent) {
                    completionHandler(.success(id))
                    return
                }
                completionHandler(.success(0))
            }
            task.resume()
        }
        
        if request.isTokenRequired {
            refreshTokens { result in
                switch result {
                case .failure(let error):
                    completionHandler(.failure(error))
                    return
                case .success:
                    launchTask()
                }
            }
        } else {
            launchTask()
        }
    }
    
    func fetchIssues(ids: [Int], parse: @escaping ([String : Any]) -> Issues?, completionHandler: @escaping (APIResult<[Issues]>) -> Void) {
        let refreshTokensCompletion = { (result: Result<Void, Error>) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success:
                let dispatchGroup = DispatchGroup()
                var results: [Issues] = []
                for id in ids {
                    dispatchGroup.enter()
                    let requestToFetchIssues = ForecastType.IssueWithId(id: id)
                    var requestToFetch = requestToFetchIssues.requestWitchToken
                    requestToFetch.httpMethod = HttpMethodsString.get.stringValue
                    let task = self.JSONTaskWith(request: requestToFetch, HTTPMethod: HttpMethodsString.get) { (json, response, error, _) in
                        defer { dispatchGroup.leave() }
                        guard let HTTPResponse = response else {
                            let error = error ?? NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no error message provided").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no error message provided").errorMessage])
                            completionHandler(.failure(error))
                            return
                        }
                        
                        let responseError = INDNetworkingError(statusCode: HTTPResponse.statusCode, message: error?.localizedDescription)

                        if !(200...299).contains(HTTPResponse.statusCode) {
                            return completionHandler(.failure(responseError))
                        }
                        
                        guard let json = json else {
                            let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no JSON response").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no JSON response").errorMessage])
                            completionHandler(.failure(error))
                            return
                        }
                        if let result = parse(json) {
                            results.append(result)
                        } else {
                            let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorMessage])
                            completionHandler(.failure(error))
                            return
                        }
                    }
                    task.resume()
                }
                dispatchGroup.notify(queue: .main) {
                    completionHandler(.success(results))
                }
            }
        }
        refreshTokens(completion: refreshTokensCompletion)
    }
    
    func validateCredentials(credentials: AuthBody, completion: @escaping (Result<Int, Error>) -> Void) {
        var request = ForecastType.Token(credentials: credentials).requestWitchOutToken
        request.httpMethod = HttpMethodsString.post.stringValue
        do {
            let jsonData = try JSONEncoder().encode(credentials)
            request.httpBody = jsonData
        } catch {
            let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.encodingFailed.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.encodingFailed.errorMessage])
            completion(.failure(error))
            return
        }
        let task = JSONTaskWith(request: request, HTTPMethod: .post) { (json, response, error, method) in
            guard let HTTPResponse = response else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.errorMessage])
                completion(.failure(error))
                return
            }
            let responseError = INDNetworkingError(statusCode: HTTPResponse.statusCode, message: error?.localizedDescription)

            if !(200...299).contains(HTTPResponse.statusCode) {
                return completion(.failure(responseError))
            }
    
            guard let json = json else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no JSON response").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no JSON response").errorMessage])
                completion(.failure(error))
                return
            }
            
            do {
                if let jsonString = json["response"] as? String {
                    let jwt = try decode(jwt: jsonString)
                    let idEmployee = jwt.claim(name: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier").integer
                    if let id = idEmployee, let exp = jwt.claim(name: "exp").integer,
                       let nbf = jwt.claim(name: "nbf").integer {
                        self.saveAuthTokens(tokens: TokenInfo(token: jsonString, expiresAt: Int64(exp), notValidBefore: Int64(nbf)))
                        self.saveAuthBody(authBody: credentials)
                        self.accessToken = self.getAccessToken()
                        completion(.success(id))
                    } else {
                        let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorMessage])
                        completion(.failure(error))
                    }
                } else {
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorMessage])
                    completion(.failure(error))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func deleteItem(request: ForecastType, completionHandler: @escaping (APIResult<Void>) -> Void) {
        let refreshTokensCompletion = { (result: Result<Void, Error>) in
            switch result {
            case .failure(let error):
                completionHandler(.failure(error))
            case .success:
                var request = request.requestWitchToken
                request.httpMethod = HttpMethodsString.delete.stringValue
                let task = self.JSONTaskWith(request: request, HTTPMethod: .delete) { (_, response, error, _) in
                    guard let HTTPResponse = response else {
                        let error = error ?? NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no error message provided").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no error message provided").errorMessage])
                        completionHandler(.failure(error))
                        return
                    }
                    
                    let responseError = INDNetworkingError(statusCode: HTTPResponse.statusCode, message: error?.localizedDescription)

                    if !(200...299).contains(HTTPResponse.statusCode) {
                        return completionHandler(.failure(responseError))
                    }
                    
                    completionHandler(.success(()))
                }
                task.resume()
            }
        }
        refreshTokens(completion: refreshTokensCompletion)
    }
    
    func refreshTokens(completion: @escaping (Result<Void, Error>) -> Void) {
        if !needReAuth {
            completion(.success(()))
            return
        }
        guard let authBody = self.getAccessAuthBody() else {
            let error = INDNetworkingError.unexpectedResponse(message: "Invalid access auth body")
            completion(.failure(error))
            return
        }
        var refreshRequest = ForecastType.Token(credentials: authBody).requestWitchOutToken
        refreshRequest.httpMethod = HttpMethodsString.post.stringValue
        do {
            if let authBody = getAccessAuthBody() {
                let jsonData = try JSONEncoder().encode(authBody)
                refreshRequest.httpBody = jsonData
            }
        } catch {
            let error = INDNetworkingError.unexpectedResponse(message: "Failed to encode auth body")
            completion(.failure(error))
            return
        }
        
        let task = URLSession.shared.dataTask(with: refreshRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = INDNetworkingError.unexpectedResponse(message: "Unexpected HTTP response")
                completion(.failure(error))
                return
            }
            guard let data = data else {
                let error = INDNetworkingError.unexpectedResponse(message: "No data in response")
                completion(.failure(error))
                return
            }
            if let jsonString = String(data: data, encoding: .utf8),
               let jwt = try? decode(jwt: jsonString),
               let exp = jwt.claim(name: "exp").integer,
               let nbf = jwt.claim(name: "nbf").integer {
                self.saveAuthTokens(tokens: TokenInfo(token: jsonString, expiresAt: Int64(exp), notValidBefore: Int64(nbf)))
                self.saveAuthBody(authBody: authBody)
                self.accessToken = self.getAccessToken()
                completion(.success(()))
            } else {
                let error = INDNetworkingError.unexpectedResponse(message: "Failed to decode JWT or missing claims")
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    /**
     Checks if re-authorization is needed based on the expiration of the access token.
     - Returns: A boolean value indicating whether re-authorization is needed.
     */
    private var needReAuth: Bool {
        guard let expiresAt = accessToken?.expiresAt else {
            return true
        }
        let currentTimestamp = Date().timeIntervalSince1970
        let expiresAtTimestamp = TimeInterval(expiresAt)
        let reAuthThreshold: TimeInterval = 5 * 60
        return currentTimestamp + reAuthThreshold >= expiresAtTimestamp
    }
    
    /**
     The configuration object used to create the session.
     */
    internal let sessionConfiguration: URLSessionConfiguration
    
    /**
     The session object that performs the data transfers.
     */
    internal lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    }()
    
    /**
     Initializes a new instance of the URLSessionManager class.
     - Parameter sessionConfiguration: The configuration object used to create the session.
     */
    init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
        accessToken = TokenInfo(token: "", expiresAt: 0, notValidBefore: 0)
        accessToken = getAccessToken()
    }
    
    /**
     Initializes a new instance of the URLSessionManager class using the default session configuration.
     */
    convenience init() {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
}

extension APIManagerIndustry: KeychainWorkerProtocol {
    static var KEY_AUTH_BODY_EMAIL: String = "key_auth_body_email"
    static var KEY_AUTH_BODY_PASSWORD: String = "key_auth_body_password"
    static let KEY_ACCESS_TOKEN = "auth_token"
    static let KEY_ACCESS_TOKEN_EXPIRE = "auth_token_expire"
    static let ACCESS_TOKEN_LIFE_THRESHOLD_SECONDS: Int64 = 3600
    static var KEY_ACCESS_TOKEN_NBF: String = "key_access_token_nbf"
    
    private func onTokensRefreshed(tokens: TokenInfo) {
        saveAuthTokens(tokens: tokens)
        accessToken = getAccessToken()
    }
    
    private func dropToken() {
        accessToken = TokenInfo(token: "", expiresAt: 0, notValidBefore: 0)
        dropTokens()
    }
}
