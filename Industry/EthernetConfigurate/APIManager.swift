//
//  APIManager.swift
//  Industry
//
//  Created by Birdus on 23.03.2023.
//

import Foundation
// MARK: - APIManagerIndustry

/**
 The APIManagerIndustry class is responsible for making network requests and parsing responses for the Industry app.
 */
final class APIManagerIndustry: APIManager {
    /**
     Makes a network request to fetch an array of objects that conform to `JSONDecodable`.
     - Parameters:
        -  request The `URLRequest` object that defines the network request to be made.
        -  HTTPMethod The HTTP method used to make the request.
        -  parse: A closure that takes a dictionary of `[String: Any]` as input and returns an array of objects that conform to `JSONDecodable`.
        -  completionHandler: A closure that takes an `APIResult` object as input and has no return value.
     */
    func fetch<T>(request: URLRequest, HTTPMethod: HttpMethodsString, parse: @escaping ([String : Any]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void) where T : Decodable {
        var requestToFetch = request
        requestToFetch.httpMethod = HTTPMethod.stringValue
        let task = JSONTaskWith(request: requestToFetch, HTTPMethod: HTTPMethod) { (json, response, error, _) in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: error.localizedDescription).errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                        completionHandler(.failure(error))
                    } else {
                        let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error: JSON empty").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                        completionHandler(.failure(error))
                    }
                    return
                }
                if let result = parse(json) {
                    completionHandler(.success(result as! T))
                } else {
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error: JSON failed copy").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
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
    func fetch<T>(request: URLRequest, HTTPMethod: HttpMethodsString, id: Int?, parse: @escaping ([String: Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) where T: JSONDecodable {
        var requestToFetch = request
        if let id = id {
            let urlString = "\(request.url!.absoluteString)/\(id)"
            guard let url = URL(string: urlString) else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.notFound.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.notFound.localizedDescription])
                completionHandler(.failure(error))
                return
            }
            requestToFetch.url = url
        }
        requestToFetch.httpMethod = HTTPMethod.stringValue
        let task = JSONTaskWith(request: requestToFetch, HTTPMethod: HTTPMethod) { (json, response, error, _) in
            DispatchQueue.main.async {
                guard let json = json else {
                    if let error = error {
                        let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: error.localizedDescription).errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: error.localizedDescription).localizedDescription])
                        completionHandler(.failure(error))
                    } else {
                        let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error: unxepceted").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error: unxepceted")])
                        completionHandler(.failure(error))
                    }
                    return
                }
                if let result = parse(json) {
                    completionHandler(.success(result))
                } else {
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.badRequest.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.errorMessage])
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
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
       }
       
       /**
        Initializes a new instance of the URLSessionManager class using the default session configuration.
        */
       convenience init() {
           self.init(sessionConfiguration: URLSessionConfiguration.default)
       }
}
