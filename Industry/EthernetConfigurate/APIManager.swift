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
    func fetch<T>(request: ForecastType, HTTPMethod: HttpMethodsString, parse: @escaping ([[String: Any]]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void) where T: Decodable {
        let dataTask = JSONTaskWithArray(request: request.requestWitchToken, HTTPMethod: HTTPMethod) { (json, response, error, _) in
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
    func fetch<T>(request: ForecastType, HTTPMethod: HttpMethodsString, parse: @escaping ([String : Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) where T : Decodable {
        var requestToFetch = request.requestWitchToken
        requestToFetch.httpMethod = HTTPMethod.stringValue
        let task = JSONTaskWith(request: requestToFetch, HTTPMethod: HTTPMethod) { (json, response, error, _) in
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
    
    func fetchIssues(HTTPMethod: HttpMethodsString, ids: [Int], parse: @escaping ([String : Any]) -> Issues?, completionHandler: @escaping (APIResult<[Issues]>) -> Void) {
        
        let dispatchGroup = DispatchGroup()
        
        // Массив для сохранения результатов
        var results: [Issues] = []
        
        for id in ids {
            dispatchGroup.enter()
            // Обновляем URL запроса для каждого ID
            let requestToFetchIssues = ForecastType.IssueWithId(id: id)
            var requestToFetch = requestToFetchIssues.requestWitchToken
            requestToFetch.httpMethod = HTTPMethod.stringValue
            let task = JSONTaskWith(request: requestToFetch, HTTPMethod: HTTPMethod) { (json, response, error, _) in
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
        request.httpMethod = "POST"
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
            // Валидация успешна, сохраняем токены
            guard let data = data else {
                completion(.failure(INDNetworkingError.decodingFailed))
                return
            }
            do {
                if let jsonString = String(data: data, encoding: .utf8) {
                    let jwt = try decode(jwt: jsonString)
                    let idEmployee = jwt.claim(name: "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier").integer
                    let exp = jwt.claim(name: "exp").integer
                    if let id = idEmployee, let exp = exp {
                        self.saveAuthTokens(tokens: TokenInfo(token: jsonString, expiresAt: Int64(exp)))
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
               let exp = jwt.claim(name: "exp").integer {
                self.saveAuthTokens(tokens: TokenInfo(token: jsonString, expiresAt: Int64(exp)))
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
    
    /**
     Checks if re-authorization is needed based on the expiration of the access token.
     - Returns: A boolean value indicating whether re-authorization is needed.
     */
    private var needReAuth: Bool {
        guard let expiresAt = accessToken?.expiresAt else {
            return true
        }
        let currentTimestamp = Date().timeIntervalSince1970
        let currentTimestamps = TimeInterval(currentTimestamp)
        let expiresAtTimestamp = TimeInterval(expiresAt)

        return currentTimestamps > expiresAtTimestamp
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
        accessToken = TokenInfo(token: "", expiresAt: 0)
        refreshToken = TokenInfo(token: "", expiresAt: 0)
        accessToken = getAccessToken()
        refreshToken = getRefreshToken()
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
    static let KEY_REFRESH_TOKEN = "refresh_token"
    static let KEY_REFRESH_TOKEN_EXPIRE = "refresh_token_expire"
    static let ACCESS_TOKEN_LIFE_THRESHOLD_SECONDS: Int64 = 3600
    
    private func onTokensRefreshed(tokens: TokenInfo) {
        saveAuthTokens(tokens: tokens)
        accessToken = getAccessToken()
        refreshToken = getRefreshToken()
    }
    
    private func dropToken() {
        accessToken = TokenInfo(token: "", expiresAt: 0)
        refreshToken = TokenInfo(token: "", expiresAt: 0)
        dropTokens()
    }
}
