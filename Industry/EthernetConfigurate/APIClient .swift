//
//  APIManger.swift
//  Weather
//
//  Created by Даниил Гетманцев on 29.11.2022.
//
import Foundation

// MARK: - typealias
typealias JSONTask = URLSessionDataTask
typealias JSONCompletionHandler = ([String: Any]?, HTTPURLResponse?, Error?, String?) -> Void

// MARK: - enum APIResult
enum APIResult<T> {
    case success(T)
    case successArray([T])
    case failure(Error)
}

// MARK: - protocol APIManager
protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    func JSONTaskWith(request: URLRequest, HTTPMethod: HttpMethodsString, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    func fetch<T: Decodable>(request: URLRequest, HTTPMethod: HttpMethodsString, _ id: Int?, parse: @escaping ([String: Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
    func fetch<T: Decodable>(request: URLRequest, HTTPMethod: HttpMethodsString, parse: @escaping ([String: Any]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void)
}

// MARK: - Default use of the function
extension APIManager {
    func JSONTaskWith(request: URLRequest, HTTPMethod: HttpMethodsString, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        var request = request
        request.httpMethod = HTTPMethod.methods
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil, let HTTPResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
                return completionHandler(nil, nil, error, nil)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                completionHandler(json, HTTPResponse, nil, HTTPMethod.methods)
            } catch {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.badRequest.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                completionHandler(nil, HTTPResponse, error , HTTPMethod.methods)
            }
        }
        return task
    }
    
    func fetch<T>(request: URLRequest, HTTPMethod: HttpMethodsString, _ id: Int?, parse: @escaping ([String: Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let dataTask = JSONTaskWith(request: request, HTTPMethod: HTTPMethod) { (json, response, error, _) in
            guard let json = json else {
                if let error = error {
                    completionHandler(.failure(error))
                }
                return
            }
            if let item = parse(json) {
                completionHandler(.success(item))
            } else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error: Parse data").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                completionHandler(.failure(error))
            }
        }
        dataTask.resume()
    }
    
    func fetch<T>(request: URLRequest, HTTPMethod: HttpMethodsString, parse: @escaping ([String: Any]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void) {
           let dataTask = JSONTaskWith(request: request, HTTPMethod: HTTPMethod) { (json, response, error, _) in
               guard let json = json else {
                   if let error = error {
                       completionHandler(.failure(error))
                   }
                   return
               }
               if let items = parse(json) {
                   completionHandler(.successArray(items))
               } else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error: Parse array data").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                completionHandler(.failure(error))
                
               }
           }
        dataTask.resume()
    }
}
