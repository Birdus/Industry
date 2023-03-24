//
//  HttpMetods.swift
//  Industry
//
//  Created by Birdus on 24.03.2023.
//

import Foundation

enum HttpMethodsString {
    case Get
    case Post
    case Put
    case Dleate
    
    var methods: String {
        switch self {
        case .Get:
            return "GET"
        case .Post:
            return "POST"
        case .Put:
            return "PUT"
        case .Dleate:
            return "DELETE"
        }
    }
}
