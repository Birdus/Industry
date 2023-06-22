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
    //MARK: - Properties
    private var accessToken: TokenInfo?
    
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
    
    //MARK: - Initialization
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
    
    //MARK: - fetch get array object
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
    
    //MARK: - Fetch get single object
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
    
    //MARK: - Put
    /**
    Makes a network request to update a single object that conforms to `Encodable`.

    - Parameters:
       - request: The `URLRequest` object that defines the network request to be made.
       - data: The object to be updated, which conforms to `Encodable`.
       - completionHandler: A closure that takes an `APIResult` object as input and has no return value.

    - Returns: Void
    */
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
    
    //MARK: - Post
    /**
    Makes a network request to create a new object that conforms to `Encodable`.

    - Parameters:
       - request: The `URLRequest` object that defines the network request to be made.
       - data: The object to be created, which conforms to `Encodable`.
       - completionHandler: A closure that takes an `APIResult` object as input and has no return value.

    - Returns: Void
    */
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
    
    //MARK: - Fetch Image
    /**
    Fetches an image from the network.

    - Parameters:
       - url: The URL of the image to be fetched.
       - completionHandler: A closure that takes an `APIResult` object as input and has no return value.

    - Returns: Void
    */
    func fetchImage(request: ForecastType, imagePath: String, completionHandler: @escaping (Result<UIImage, Error>) -> Void) {
        var requestToGetImage = request.requestWitchToken
        requestToGetImage.httpMethod = HttpMethodsString.post.stringValue
        let boundary = "Boundary-\(UUID().uuidString)"
        let body = "--\(boundary)\r\nContent-Disposition:form-data; name=\"imagePath\"\r\n\r\n\(imagePath)\r\n--\(boundary)--\r\n"
        let postData = body.data(using: .utf8)
        requestToGetImage.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        requestToGetImage.httpBody = postData
        let task = URLSession.shared.dataTask(with: requestToGetImage) { (data, response, error) in
            if let error = error {
                return completionHandler(.failure(INDNetworkingError.init(statusCode: (response as? HTTPURLResponse)?.statusCode, message: error.localizedDescription)))
            }
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let error = INDNetworkingError.missingHTTPResponse
                return completionHandler(.failure(error))
            }
            if !(200...299).contains(HTTPResponse.statusCode) {
                let responseError = INDNetworkingError(statusCode: HTTPResponse.statusCode, message: "Server returned status code: \(HTTPResponse.statusCode)")
                return completionHandler(.failure(responseError))
            }
            guard let data = data else {
                let error = INDNetworkingError.unexpectedResponse(message: "Unexpected error: no data response")
                return completionHandler(.failure(error))
            }
            DispatchQueue.global().async {
                guard let image = UIImage(data: data) else {
                    let error = INDNetworkingError.unexpectedResponse(message: "Error parsing image data")
                    return completionHandler(.failure(error))
                }
                DispatchQueue.main.async {
                    completionHandler(.success(image))
                }
            }
        }
        task.resume()
    }
    //MARK: - Upload Image
    func uploadImage(request: ForecastType, employee: Employee, completionHandler: @escaping (Result<Data, Error>) -> Void) {
        let boundary = "Boundary-\(UUID().uuidString)"
        guard let imageData = UserDefaults.standard.data(forKey: "UserImage"), let image = UIImage(data: imageData), let imageDataJPEG = image.pngData() else {
            let error = NSError(domain: "ImageError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to load image from UserDefaults"])
            completionHandler(.failure(error))
            return
        }
        var requestToUploadImage = request.requestWitchToken
        requestToUploadImage.httpMethod = HttpMethodsString.putch.stringValue
        requestToUploadImage.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        guard let oneCPass =  employee.oneCPass else {
            return
        }
        var body = Data()
        let params = [
            "firstName": employee.firstName,
            "secondName": employee.secondName,
            "lastName": employee.lastName,
            "role": employee.role,
            "email": employee.email,
            "id": employee.id,
            "divisionId": employee.divisionId,
            "serviceNumber": employee.serviceNumber,
            "oneCPass": String(describing: oneCPass),
            "post": employee.post
        ] as [String : Any]
        for (key, value) in params {
            if let data = "--\(boundary)\r\nContent-Disposition: form-data; name=\"\(key)\"\r\n\r\n\(value)\r\n".data(using: .utf8) {
                body.append(data)
            }
        }
        if let data = "--\(boundary)\r\nContent-Disposition: form-data; name=\"file\"; filename=\"image.png\"\r\nContent-Type: image/png\r\n\r\n".data(using: .utf8) {
            body.append(data)
        }
        body.append(imageDataJPEG)
        
        if let data = "\r\n--\(boundary)--\r\n".data(using: .utf8) {
            body.append(data)
        }
        requestToUploadImage.httpBody = body
        let task = URLSession.shared.dataTask(with: requestToUploadImage) { (data, response, error) in
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            guard let HTTPResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: "NetworkingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Missing HTTP response"])
                completionHandler(.failure(error))
                return
            }
            
            if !(200...299).contains(HTTPResponse.statusCode) {
                let responseError = NSError(domain: "NetworkingError", code: HTTPResponse.statusCode, userInfo: [NSLocalizedDescriptionKey: "Server returned status code: \(HTTPResponse.statusCode)"])
                completionHandler(.failure(responseError))
                return
            }
            guard let data = data else {
                let error = NSError(domain: "NetworkingError", code: -1, userInfo: [NSLocalizedDescriptionKey: "Unexpected error: no data response"])
                completionHandler(.failure(error))
                return
            }
            completionHandler(.success(data))
        }
        task.resume()
    }

    //MARK: - Fetch Issues
    /**
    Fetches an array of issues from the network.

    - Parameters:
       - ids: An array of `Int` values that represent the IDs of the issues to be fetched.
       - parse: A closure that takes a dictionary of `[String: Any]` as input and returns an `Issues` object.
       - completionHandler: A closure that takes an `APIResult` object as input and has no return value.

    - Returns: Void
    */
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
    
    //MARK: - Validate Credentials
    /**
    Validates the provided credentials.

    - Parameters:
       - credentials: An `AuthBody` object that contains the credentials to be validated.
       - completion: A closure that takes a `Result` object as input and has no return value.

    - Returns: Void
    */
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
    
    //MARK: - Delete Item
    /**
    Deletes an item.

    - Parameters:
       - request: The `ForecastType` object that defines the network request to be made.
       - completionHandler: A closure that takes an `APIResult` object as input and has no return value.

    - Returns: Void
    */
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
    
    //MARK: - Refresh Tokens
    /**
    Refreshes the access and refresh tokens.

    - Parameters:
       - completion: A closure that takes a `Result` object as input and has no return value.

    - Returns: Void
    */
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
    
    //MARK: - Need ReAuth
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
}

//MARK: - KeychainWorkerProtocol
extension APIManagerIndustry: KeychainWorkerProtocol {
    //MARK: - Properties
    static var KEY_AUTH_BODY_EMAIL: String = "key_auth_body_email"
    static var KEY_AUTH_BODY_PASSWORD: String = "key_auth_body_password"
    static let KEY_ACCESS_TOKEN = "auth_token"
    static let KEY_ACCESS_TOKEN_EXPIRE = "auth_token_expire"
    static let ACCESS_TOKEN_LIFE_THRESHOLD_SECONDS: Int64 = 3600
    static var KEY_ACCESS_TOKEN_NBF: String = "key_access_token_nbf"

    //MARK: - On Tokens Refreshed
    /**
    Called when tokens are refreshed. Saves the new tokens and updates the access token.

    - Parameters:
       - tokens: The new tokens to be saved.

    - Returns: Void
    */
    private func onTokensRefreshed(tokens: TokenInfo) {
        saveAuthTokens(tokens: tokens)
        accessToken = getAccessToken()
    }
    
    //MARK: - Drop Token
    /**
    Drops the current token and resets the access token.

    - Returns: Void
    */
    private func dropToken() {
        accessToken = TokenInfo(token: "", expiresAt: 0, notValidBefore: 0)
        dropTokens()
    }
}

