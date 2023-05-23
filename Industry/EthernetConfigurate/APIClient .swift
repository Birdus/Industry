//
//  APIManger.swift
//  Industry
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
    func fetch<T: Decodable>(request: ForecastType, HTTPMethod: HttpMethodsString, parse: @escaping ([String: Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void)
    
    /// Fetches an array of objects of type T for given request, HTTP method, parsing function, and completion handler.
    ///
    /// - Parameters:
    ///   - request: The URL request.
    ///   - HTTPMethod: The HTTP method to use for the request.
    ///   - parse: The function to use for parsing the JSON response.
    ///   - completionHandler: The completion handler to call when the request is complete.
    func fetch<T: Decodable>(request: ForecastType, HTTPMethod: HttpMethodsString, parse: @escaping ([String: Any]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void)
    
    func fetchIssues(request: ForecastType, HTTPMethod: HttpMethodsString, ids: [Int], parse: @escaping ([String : Any]) -> Issues?, completionHandler: @escaping (APIResult<Issues>) -> Void)
    
    func deleteItem(request: ForecastType, completionHandler: @escaping (APIResult<Void>) -> Void)
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
        let task = session.dataTask(with: request) { (data, response, error) in
            guard let data = data, error == nil, let HTTPResponse = response as? HTTPURLResponse else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
                return completionHandler(nil, nil, error, nil)
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                completionHandler(json, HTTPResponse, nil, HTTPMethod.stringValue)
            } catch {
                // Если ответ не может быть преобразован в JSON, попробуйте преобразовать его в строку.
                if let stringResponse = String(data: data, encoding: .utf8) {
                    // Оборачиваем строку в словарь перед возвратом обратно
                    completionHandler(["response": stringResponse], HTTPResponse, nil, HTTPMethod.stringValue)
                } else {
                    // Если и это не получилось, то верните ошибку.
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.badRequest.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.badRequest.localizedDescription])
                    completionHandler(nil, HTTPResponse, error , HTTPMethod.stringValue)
                }
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
    func fetch<T>(request: ForecastType, HTTPMethod: HttpMethodsString, _ id: Int?, parse: @escaping ([String: Any]) -> T?, completionHandler: @escaping (APIResult<T>) -> Void) {
        let dataTask = JSONTaskWith(request: request.request, HTTPMethod: HTTPMethod) { (json, response, error, _) in
            guard response != nil else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
                completionHandler(.failure(error))
                return
            }
            guard let json = json else {
                if let error = error {
                    completionHandler(.failure(error))
                }
                return
            }
            if let item = parse(json) {
                completionHandler(.success(item))
            } else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorMessage])
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
    func fetch<T>(request: ForecastType, HTTPMethod: HttpMethodsString,id: Int?, parse: @escaping ([String: Any]) -> [T]?, completionHandler: @escaping (APIResult<T>) -> Void) -> JSONTask {
        let dataTask = JSONTaskWith(request: request.request, HTTPMethod: HTTPMethod) { (json, response, error, _) in
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
    
    func fetchIssues(request: ForecastType, HTTPMethod: HttpMethodsString, ids: [Int], parse: @escaping ([String : Any]) -> Issues?, completionHandler: @escaping (APIResult<Issues>) -> Void) {
        
        // Создаем DispatchGroup
        let dispatchGroup = DispatchGroup()
        
        // Массив для сохранения результатов
        var results: [Issues] = []
        
        for id in ids {
            // Обновляем URL запроса для каждого ID
            var requestToFetch = request.request
            requestToFetch.url = requestToFetch.url?.appendingPathComponent("\(id)")
            requestToFetch.httpMethod = HTTPMethod.stringValue

            dispatchGroup.enter()
            let task = JSONTaskWith(request: requestToFetch, HTTPMethod: HTTPMethod) { (json, response, error, _) in
                guard let json = json else {
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.errorMessage])
                    completionHandler(.failure(error))
                    dispatchGroup.leave()
                    return
                }
                if let result = parse(json) {
                    results.append(result)
                } else {
                    let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Error parsing JSON").errorMessage])
                    completionHandler(.failure(error))
                }
                dispatchGroup.leave()
            }
            task.resume()
        }
        
        // Вызовем completionHandler когда все запросы завершены
        dispatchGroup.notify(queue: .main) {
            completionHandler(.successArray(results))
        }
    }

    func deleteItem(request: ForecastType, completionHandler: @escaping (APIResult<Void>) -> Void) -> URLSessionDataTask {
        var request = request.request
        request.httpMethod = HttpMethodsString.delete.stringValue
        let task = JSONTaskWith(request: request, HTTPMethod: .delete) { (_, response, error, _) in
            guard let httpResponse = response, httpResponse.statusCode == 200 else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.missingHTTPResponse.errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.missingHTTPResponse.localizedDescription])
                completionHandler(.failure(error))
                return
            }
            if let error = error {
                completionHandler(.failure(error))
                return
            }
            if response != nil {
                completionHandler(.success(()))
                return
            } else {
                let error = NSError(domain: INDNetworkingError.errorDomain, code: INDNetworkingError.unexpectedResponse(message: "Unexpected response").errorCode, userInfo: [NSLocalizedDescriptionKey: INDNetworkingError.unexpectedResponse(message: "Unexpected response").errorMessage])
                completionHandler(.failure(error))
                return
            }
        }
        task.resume()
        return task
    }



}
