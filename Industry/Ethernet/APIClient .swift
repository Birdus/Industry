//
//  APIClient .swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation

class APIClient {
    
    let baseURL = "https://example.com/api/"
    
    func sendRequest<T: Codable>(path: String, method: String, parameters: [String: Any]?, completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: baseURL + path) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        
        if let parameters = parameters {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
            } catch {
                completion(.failure(APIError.serializationError))
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let response = try decoder.decode(T.self, from: data)
                completion(.success(response))
            } catch {
                completion(.failure(APIError.decodingError))
            }
        }
        
        task.resume()
    }
}

enum APIError: Error {
    case invalidURL
    case noData
    case serializationError
    case decodingError
}

