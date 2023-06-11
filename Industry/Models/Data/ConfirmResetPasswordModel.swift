//
//  ConfirmResetPasswordModel.swift
//  Industry
//
//  Created by  Даниил on 07.06.2023.
//

import Foundation

struct ConfirmResetPassword: Codable, Equatable {
    let confirmationCode: Int
    let newPassword: String?
}

extension ConfirmResetPassword: JSONDecodable {
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard let confirmationCode = json["confirmationCode"] as? Int,
              let newPassword = json["newPassword"] as? String else {
            return nil
        }
        return ConfirmResetPassword(confirmationCode: confirmationCode, newPassword: newPassword)
    }
}
