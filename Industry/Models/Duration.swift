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
        switch self {
        case .week:
            return ["Понедельник".localized,"Вторник".localized,"Среда".localized,"Четверг".localized,"Пятница".localized,"Суббота".localized]
        case .month:
            let formatter = DateFormatter()
            return (1...12).compactMap { month in
                formatter.monthSymbols[month - 1]
            }
        case .year:
            return ["01","02","03","04","05","06","07","08","09","10","11","12"]
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

