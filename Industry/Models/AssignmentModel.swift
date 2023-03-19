//
//  AssignmentModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation

struct Assignment: Codable {
    let id: Int
    let taskName: String
    let projectId: Int
    let taskDiscribe: String
    let project: Project
    let laborCosts: [String]
}
