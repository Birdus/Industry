//
//  Duration.swift
//  Industry
//
//  Created by  Даниил on 26.04.2023.
//

import Foundation

enum Duration {
    
    case week
    case month
    case year
    
    var description: [String] {
        let formatter = DateFormatter()
        let calendar = Calendar.current
        let now = Date()
        
        switch self {
        case .week:
            return formatter.weekdaySymbols
        case .month:
            let year = calendar.component(.year, from: now)
            let month = calendar.component(.month, from: now)
            var components = DateComponents()
            components.year = year
            components.month = month
            let date = calendar.date(from: components)!
            let range = calendar.range(of: .day, in: .month, for: date)!
            return range.map { "\($0)" }
        case .year:
            return formatter.monthSymbols
        }
    }
    
    var chartDescription: String {
        switch self {
        case .week:
            return "Статистика по неделе".localized
        case .month:
            return "Статистика по месяцу".localized
        case .year:
            return "Статистика по году".localized
        }
    }
}
