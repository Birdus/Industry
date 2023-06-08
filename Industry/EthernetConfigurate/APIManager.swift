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
            }
        }
        var requestToFetch = request.requestWitchToken
        requestToFetch.httpMethod = HttpMethodsString.get.stringValue
        let dataTask = JSONTaskWithArray(request: requestToFetch, HTTPMethod: HttpMethodsString.get) { (json, response, error, _) in
            guard response != nil else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
                completionHandler(.failure(error))
                return
            }
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let json = json else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no JSON response").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no JSON response").errorMessage])
                completionHandler(.failure(error))
                return
            }
            let compactedJSON = json.compactMap { $0 }
            if let result = parse(compactedJSON) {
                completionHandler(.successArray(result))
            } else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorMessage])
                completionHandler(.failure(error))
            }
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
            }
        }
        var requestToFetch = request.requestWitchToken
        requestToFetch.httpMethod = HttpMethodsString.get.stringValue
        let task = JSONTaskWith(request: requestToFetch, HTTPMethod: HttpMethodsString.get) { (json, response, error, _) in
            guard response != nil else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
                completionHandler(.failure(error))
                return
            }
            guard let json = json else {
                if let error = error {
                    completionHandler(.failure(error))
                } else {
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no error message provided").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no error message provided").errorMessage])
                    completionHandler(.failure(error))
                }
                return
            }
            if let result = parse(json) {
                completionHandler(.success(result))
            } else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorMessage])
                completionHandler(.failure(error))
            }
        }
        task.resume()
    }
    
    func put<T>(request: ForecastType, data: T, completionHandler: @escaping (APIResult<Int>) -> Void) where T : Encodable {
        refreshTokens { result in
            if case .failure(let error) = result {
                completionHandler(.failure(error))
            }
        }
        var requestToPut = request.requestWitchToken
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(data) else {
            let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.encodingFailed.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.encodingFailed.errorMessage])
            completionHandler(.failure(error))
            return
        }
        requestToPut.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestToPut.httpMethod = HttpMethodsString.put.stringValue
        requestToPut.httpBody = data
        let task = JSONTaskWith(request: requestToPut, HTTPMethod: HttpMethodsString.put) { (json, response, error, _) in
            guard let httpResponse = response,
                  httpResponse.statusCode == 200 else {
                let error = error ?? NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorMessage])
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success(httpResponse.statusCode))
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
        requestToPost.addValue("application/json", forHTTPHeaderField: "Content-Type")
        requestToPost.httpMethod = HttpMethodsString.post.stringValue
        requestToPost.httpBody = data
        
        if request.isTokenRequired {
            refreshTokens { result in
                if case .failure(let error) = result {
                    completionHandler(.failure(error))
                }
            }
        }
        
        let task = JSONTaskWith(request: requestToPost, HTTPMethod: HttpMethodsString.post) { (json, response, error, _) in
            guard let httpResponse = response else {
                let error = error ?? INDNetworkingError.unexpectedResponse(message: "Error parsing JSON")
                completionHandler(.failure(error))
                return
            }
            
            if httpResponse.statusCode == 201,
               let locationHeader = httpResponse.allHeaderFields["Location"] as? String,
               let url = URL(string: locationHeader),
               let id = Int(url.lastPathComponent) {
                completionHandler(.success(id))
                return
            }
            
            if httpResponse.statusCode != 200 {
                let error = INDNetworkingError.unexpectedResponse(message: "Unexpected status code")
                completionHandler(.failure(error))
                return
            }
            
            guard let json = json, let responseValue = json["response"] as? String else {
                completionHandler(.success(0))
                return
            }
            
            guard let successCode = Bool(responseValue) else {
                completionHandler(.success(0))
                return
            }
            
            if successCode {
                completionHandler(.success(0))
            } else {
                let error = INDNetworkingError.unexpectedResponse(message: "Код не действителен!".localized)
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success(0))
        }
        
        task.resume()
    }
    
    
    func fetchIssues(ids: [Int], parse: @escaping ([String : Any]) -> Issues?, completionHandler: @escaping (APIResult<[Issues]>) -> Void) {
        refreshTokens { result in
            if case .failure(let error) = result {
                completionHandler(.failure(error))
            }
        }
        let dispatchGroup = DispatchGroup()
        var results: [Issues] = []
        for id in ids {
            dispatchGroup.enter()
            let requestToFetchIssues = ForecastType.IssueWithId(id: id)
            var requestToFetch = requestToFetchIssues.requestWitchToken
            requestToFetch.httpMethod = HttpMethodsString.get.stringValue
            let task = JSONTaskWith(request: requestToFetch, HTTPMethod: HttpMethodsString.get) { (json, response, error, _) in
                defer { dispatchGroup.leave() }
                
                guard response != nil else {
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
                    completionHandler(.failure(error))
                    return
                }
                guard let json = json else {
                    if let error = error {
                        completionHandler(.failure(error))
                    } else {
                        let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no error message provided").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Unexpected error: no error message provided").errorMessage])
                        completionHandler(.failure(error))
                    }
                    return
                }
                if let result = parse(json) {
                    results.append(result)
                } else {
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorMessage])
                    completionHandler(.failure(error))
                }
            }
            task.resume()
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler(.success(results))
        }
    }
    
    func validateCredentials(credentials: AuthBody, completion: @escaping (Result<Int, Error>) -> Void) {
        
        var request = ForecastType.Token(credentials: credentials).requestWitchOutToken
        request.httpMethod = HttpMethodsString.post.stringValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            let jsonData = try JSONEncoder().encode(credentials)
            request.httpBody = jsonData
        } catch {
            completion(.failure(INDNetworkingError.encodingFailed))
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            guard let self = self else { return }
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(INDNetworkingError.missingHTTPResponse))
                return
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(INDNetworkingError.init(statusCode: httpResponse.statusCode)))
                return
            }
            guard let data = data else {
                completion(.failure(INDNetworkingError.decodingFailed))
                return
            }
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let jwt = try decode(jwt: jsonString)
                    let idEmployee = jwt.claim(name: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier").integer
                    if let id = idEmployee, let exp = jwt.claim(name: "exp").integer,
                       let nbf = jwt.claim(name: "nbf").integer {
                        self.saveAuthTokens(tokens: TokenInfo(token: jsonString, expiresAt: Int64(exp), notValidBefore: Int64(nbf)))
                        self.saveAuthBody(authBody: credentials)
                        self.accessToken = self.getAccessToken()
                        completion(.success(id))
                    } else {
                        completion(.failure(INDNetworkingError.decodingFailed))
                    }
                } else {
                    completion(.failure(INDNetworkingError.decodingFailed))
                }
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func deleteItem(request: ForecastType, completionHandler: @escaping (APIResult<Void>) -> Void) {
        refreshTokens { result in
            if case .failure(let error) = result {
                completionHandler(.failure(error))
            }
        }
        var request = request.requestWitchToken
        request.httpMethod = HttpMethodsString.delete.stringValue
        let task = JSONTaskWith(request: request, HTTPMethod: .delete) { (_, response, error, _) in
            guard response != nil else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
                completionHandler(.failure(error))
                return
            }
            if let error = error {
                completionHandler(.failure(error))
            } else {
                completionHandler(.success(()))
            }
        }
        task.resume()
    }
    
    func refreshTokens(completion: @escaping (Result<Void, Error>) -> Void) {
        if !needReAuth {
            completion(.success(()))
            return
        }
        
        guard let authBody = self.getAccessAuthBody() else {
            let error = INDNetworkingError.invalidAccessToken
            completion(.failure(error))
            return
        }
        
        var refreshRequest = ForecastType.Token(credentials: authBody).requestWitchOutToken
        refreshRequest.httpMethod = HttpMethodsString.post.stringValue
        refreshRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        do {
            if let authBody = getAccessAuthBody() {
                let jsonData = try JSONEncoder().encode(authBody)
                refreshRequest.httpBody = jsonData
            }
        } catch {
            completion(.failure(INDNetworkingError.encodingFailed))
            return
        }
        let task = URLSession.shared.dataTask(with: refreshRequest) { [weak self] (data, response, error) in
            guard let self = self else { return }
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                let error = INDNetworkingError.invalidAccessToken
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                let error = INDNetworkingError.decodingFailed
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
                let error = INDNetworkingError.decodingFailed
                completion(.failure(error))
            }
        }
        task.resume()
    }
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error loading image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data returned from server")
                completion(nil)
                return
            }
            
            let image = UIImage(data: data)
            completion(image)
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
