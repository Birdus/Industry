//
//  resetPasswordEmailModel.swift
//  Industry
//
//  Created by  Даниил on 07.06.2023.
//

import Foundation

struct ResetPasswordEmail: Codable, Equatable {
    let email: String
}

extension ResetPasswordEmail: JSONDecodable {
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard let mail = json["email"] as? String else {
            return nil
        }
        return ResetPasswordEmail(email: mail)
    }
}
