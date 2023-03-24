//
//  TabBarScreenDefinition.swift
//  Industry
//
//  Created by Даниил on 11.03.2023.
//

import Foundation

enum TabBarScreenDefinition: Int, CaseIterable {
    case userTask
    case allTask
    
    init() {
        self = .allTask
    }
    
    init?(rawValue: Int) {
        switch rawValue {
        case 0:
            self = .allTask
        case 1:
            self = .userTask
        default:
            self = .allTask
        }
    }
    
    var isScreenUserTask: Bool {
        switch self {
        case .userTask:
            return true
        case .allTask:
            return false
        }
    }
}
