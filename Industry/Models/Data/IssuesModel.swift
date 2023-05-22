//
//  IssuesModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation


public struct Issues: Codable, Equatable {
    let id: Int
    let taskName: String
    let projectId: Int
    let taskDiscribe: String
}

extension Issues: JSONDecodable {
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard let id = json["id"] as? Int,
              let taskName = json["taskName"] as? String,
              let projectId = json["projectId"] as? Int,
              let taskDiscribe = json["taskDiscribe"] as? String else {
            return nil
        }
        return Issues(id: id, taskName: taskName, projectId: projectId, taskDiscribe: taskDiscribe)
    }
}
