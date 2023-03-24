//
//  DivisionModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation


struct Division: Codable {
    let id: Int
    let divisionName: String
    let employees: [String]
}

extension Division: JSONDecodable {
    static func decodeJSON(json: [String: Any]) -> Self? {
            guard
                let id = json["id"] as? Int,
                let divisionName = json["divisionName"] as? String,
                let employeesJson = json["employees"] as? [String]
            else {
                return nil
            }
            return Division(id: id, divisionName: divisionName, employees: employeesJson)
        }
}
