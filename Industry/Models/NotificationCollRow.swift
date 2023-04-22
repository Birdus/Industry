//
//  NotificationCollRow.swift
//  Industry
//
//  Created by Birdus on 07.04.2023.
//

import Foundation


enum NotificationCollRow {
    case event
    case deadLineTask
    case newTask
    
    var iconNotification: String {
            switch self {
            case .event:
                return "iconEvent.png"
            case .deadLineTask:
                return "iconDeadLine.png"
            case .newTask:
                return "iconNewTask.png"
            }
        }
    
}
