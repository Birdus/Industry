//
//  APIManger.swift
//  Weather
//
//  Created by Даниил Гетманцев on 29.11.2022.
//
import Foundation

/// Typealias for JSON task.
typealias JSONTask = URLSessionDataTask

/// Completion handler for JSON response.
typealias JSONCompletionHandler = ([String: Any]?, HTTPURLResponse?, Error?, String?) -> Void

/// Result of API request.
enum APIResult<T> {
    case success(T)
    case successArray([T])
    case failure(Error)
}

/// Protocol for managing API requests.
protocol APIManager {
    var sessionConfiguration: URLSessionConfiguration { get }
    var session: URLSession { get }
    
    /// Creates a JSON task for given request, HTTP method, and completion handler.
    ///
    /// - Parameters:
    ///   - request: The URL request.
    ///   - HTTPMethod: The HTTP method to use for the request.
    ///   - completionHandler: The completion handler to call when the request is complete.
    /// - Returns: A JSON task for the given request.
    func JSONTaskWith(request: URLRequest, HTTPMethod: HttpMethodsString, completionHandler: @escaping JSONCompletionHandler) -> JSONTask
    
    /// Fetches a single object of type T for given request, HTTP method, ID, parsing function, and completion handler.
    ///
    /// - Parameters:
    ///   - request: The URL request.
    ///   - HTTPMethod: The HTTP method to use for the request.
    ///   - id: The ID of the object to fetch.
    ///   - parse: The function to use for parsing the JSON response.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func fetch<T: Decodable>(request: URLRequest, HTTPMethod: HttpMethodsString, _ id: Int?, parse: @escaping ([String: Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
    
    /// Fetches an array of objects of type T for given request, HTTP method, parsing function, and completion handler.
    ///
    /// - Parameters:
    ///   - request: The URL request.
    ///   - HTTPMethod: The HTTP method to use for the request.
    ///   - parse: The function to use for parsing the JSON response.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func fetch<T: Decodable>(request: URLRequest, HTTPMethod: HttpMethodsString, parse: @escaping ([String: Any]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void)
}
// MARK: - Default use of the function
extension APIManager {
    /**
     JSONTaskWith: HTTP request with JSON data
     
     - Parameters:
        - request: The HTTP request object.
        - HTTPMethod: The HTTP request method.
        - completionHandler: The completion handler to be called when the task is complete.
     - Returns: A URLSessionDataTask object
     */
    func JSONTaskWith(request: URLRequest, HTTPMethod: HttpMethodsString, completionHandler: @escaping JSONCompletionHandler) -> JSONTask {
        var request = request
        request.httpMethod = HTTPMethod.stringValue
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil, let HTTPResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
                return completionHandler(nil, nil, error, nil)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                completionHandler(json, HTTPResponse, nil, HTTPMethod.stringValue)
            } catch {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.badRequest.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                completionHandler(nil, HTTPResponse, error , HTTPMethod.stringValue)
            }
        }
        return task
    }
    
    /**
     fetch: Get data for a single item
     
     - Parameters:
        - request: The HTTP request object
        - HTTPMethod: The HTTP request method
        - id: The id of the item to fetch
        - parse: The function used to parse the JSON data
        - completionHandler: The completion handler to be called when the task is complete
     
     */
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
    
    /**
     Fetches API data with the given request and HTTP method, parses the response data to an array of generic type T and calls the completion handler with the parsed data or error.
     
     - Parameters:
        - request: The URLRequest object representing the API request.
        - HTTPMethod: The HttpMethodsString object representing the HTTP method of the API request.
        - id: The primary key found.
        - parse: The closure that takes a dictionary object of JSON response data and returns an array of generic type T.
        - completionHandler: The closure that takes an APIResult object that holds either the parsed data or the error.
     - Returns: The JSONTask object representing the data task for the API request.
     */
    func fetch<T>(request: URLRequest, HTTPMethod: HttpMethodsString,id: Int?, parse: @escaping ([String: Any]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void) -> JSONTask {
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
        return dataTask
    }
}
