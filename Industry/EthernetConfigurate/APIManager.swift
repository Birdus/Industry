//
//  APIManager.swift
//  Industry
//
//  Created by Birdus on 23.03.2023.
//

import Foundation

final class APIManagerIndustry: APIManager {
    func fetch<T>(request: URLRequest, HTTPMethod: HttpMethodsString, parse: @escaping ([String: Any]) -> [T]?, completionHandler: @escaping (APIResult<[T]>) -> Void) where T: JSONDecodable {
        var requestToFetch = request
        requestToFetch.httpMethod = HTTPMethod.methods
        
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
                    completionHandler(.success(result))
                } else {
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error: JSON failed copy").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                    completionHandler(.failure(error))
                }
            }
        }
        task.resume()
    }
    
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
        requestToFetch.httpMethod = HTTPMethod.methods
        
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
    
    internal let sessionConfiguration: URLSessionConfiguration
    
    internal lazy var session: URLSession = {
        return URLSession(configuration: self.sessionConfiguration)
    } ()
    
    init(sessionConfiguration: URLSessionConfiguration) {
        self.sessionConfiguration = sessionConfiguration
    }
    
    convenience init() {
        self.init(sessionConfiguration: URLSessionConfiguration.default)
    }
}
