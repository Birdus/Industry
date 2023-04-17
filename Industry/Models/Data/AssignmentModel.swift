//
//  AssignmentModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation


public struct Assignment: Codable, JSONDecodable {
    let id: Int
    let taskName: String
    let projectId: Int
    let taskDiscribe: String
    let project: [Project]
    let laborCosts: [LaborCost]
    
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard let id = json["id"] as? Int,
              let taskName = json["taskName"] as? String,
              let projectId = json["projectId"] as? Int,
              let taskDiscribe = json["taskDiscribe"] as? String,
              let projectJson = json["project"] as? [[String: Any]],
              let laborCostsJson = json["laborCosts"] as? [[String: Any]] else {
            return nil
        }
        
        let projects = projectJson.compactMap { Project.decodeJSON(json: $0) }
        let laborCosts = laborCostsJson.compactMap { LaborCost.decodeJSON(json: $0) }
        
        return Assignment(id: id, taskName: taskName, projectId: projectId, taskDiscribe: taskDiscribe, project: projects, laborCosts: laborCosts)
    }
}
