//
//  AuthenticationTableRow.swift
//  Industry
//
//  Created by Даниил on 10.03.2023.
//

import Foundation
// MARK: - AuthenticationTableRow
/// AuthenticationTableRow represents the rows in the authentication table view.
enum AuthenticationTableRow: Int, CaseIterable {
    /// The login row.
    case login
    /// The password row.
    case password
    
    /// The title of the row.
    var title: String {
        switch self {
        case .login:
            return "Логин".localized
        case .password:
            return "Пароль".localized
        }
    }
    
    /// The name of the image associated with the row.
    var imageName: String {
        switch self {
        case .login:
            return "iconLogin"
        case .password:
            return "iconPass"
        }
    }
    
    /// Whether or not the row is a secure field (e.g. password).
    var isSecure: Bool {
        return self == .password
    }
}
