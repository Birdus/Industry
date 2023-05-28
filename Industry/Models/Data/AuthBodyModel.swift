//
//  AuthBodyModel.swift
//  Industry
//
//  Created by  Даниил on 27.05.2023.
//

import Foundation

struct AuthBody: Codable {
    let email: String
    let password: String
}
