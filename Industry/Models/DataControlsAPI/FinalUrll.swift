//
//  FinalUrll.swift
//  Industry
//
//  Created by Birdus on 24.03.2023.
//

import Foundation

protocol FinalURLPoint {
    var baseURL: URL { get }
    var path: String { get }
    var request: URLRequest { get }
}
