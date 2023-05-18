//
//  ProjectModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation

struct Project: Codable, Equatable {
    let id: Int
    let projectName: String
}

extension Project: JSONDecodable {
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard let id = json["id"] as? Int,
              let projectName = json["projectName"] as? String else {
            return nil
        }
        
        return Project(id: id, projectName: projectName)
    }
}
