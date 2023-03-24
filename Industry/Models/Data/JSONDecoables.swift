//
//  JSONDecoables.swift
//  Industry
//
//  Created by Birdus on 24.03.2023.
//

import Foundation

protocol JSONDecodable {
    static func decodeJSON(json: [String: Any]) -> Self?
}
