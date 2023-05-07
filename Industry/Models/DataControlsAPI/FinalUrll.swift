//
//  FinalUrll.swift
//  Industry
//
//  Created by Birdus on 24.03.2023.
//

import Foundation

// MARK: - FinalURLPoint
/// Protocol for defining the final URL to be used in networking calls.
protocol FinalURLPoint {
    /// The base URL for the endpoint.
    var baseURL: URL { get }
    /// The path component of the endpoint.
    var path: String { get }
    /// The URLRequest for the endpoint.
    var request: URLRequest { get }
}
