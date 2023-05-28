//
//  UserModel.swift
//  Industry
//
//  Created by  Даниил on 27.05.2023.
//

import Foundation

struct User: Codable {
    let id: Int64
    let accessToken: String
    let accessTokenExpire: Int64
    let refreshToken: String
    let refreshTokenExpire: Int64
}
