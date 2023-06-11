//
//  CodeResetPassword.swift
//  Industry
//
//  Created by  Даниил on 07.06.2023.
//

import Foundation

struct CodeResetPassword: Codable, Equatable {
    let confirmationCode: Int
}

extension CodeResetPassword: JSONDecodable {
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard let confirmationCode = json["confirmationCode"] as? Int else {
            return nil
        }
        return CodeResetPassword(confirmationCode: confirmationCode)
    }
}
