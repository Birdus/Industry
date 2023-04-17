//
//  ProjectModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation

struct Project: Codable, JSONDecodable {
    let id: Int
    let projectName: String
    let assignments: [Assignment]
    
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard let id = json["id"] as? Int,
              let projectName = json["projectName"] as? String,
              let assignmentsJson = json["assignments"] as? [[String: Any]] else {
            return nil
        }
        
        let assignments = assignmentsJson.compactMap { Assignment.decodeJSON(json: $0) }
        return Project(id: id, projectName: projectName, assignments: assignments)
    }
}
