//
//  ProjectModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation

struct Project: Codable {
    let id: Int
    let projectName: String
    let assignments: [Assignment]
}
