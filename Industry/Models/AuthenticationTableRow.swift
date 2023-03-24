//
//  AuthenticationTableRow.swift
//  Industry
//
//  Created by Даниил on 10.03.2023.
//

import Foundation

enum AuthenticationTableRow: Int, CaseIterable {
    case login
    case password
    
    var title: String {
        switch self {
        case .login:
            return "Логин".localized
        case .password:
            return "Пароль".localized
        }
    }
    
    var imageName: String {
        switch self {
        case .login:
            return "iconLogin"
        case .password:
            return "iconPass"
        }
    }
    
    var isSecure: Bool {
        return self == .password
    }
}
