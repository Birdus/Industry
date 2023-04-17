//
//  NotificationCollRow.swift
//  Industry
//
//  Created by Birdus on 07.04.2023.
//

import Foundation

// MARK: - NotificationCollRow

/// This enum represents a collection view cell row for notifications. It has three possible cases:
/// - event
/// - deadLineTask
/// - newTask
enum NotificationCollRow {
    // Each case represents a specific notification type and returns an icon image name as a string.
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
