//
//  LaborCostModel.swift
//  Industry
//
//  Created by Birdus on 19.03.2023.
//

import Foundation

struct LaborCost: Codable, Equatable {
    var id: Int?
    var date: Date
    var employeeId: Int
    var issueId: Int
    var hourCount: Int
}

extension LaborCost {
    static func decodeJSON(json: [String: Any]) -> Self? {
        guard let id = json["id"] as? Int,
              let dateString = json["date"] as? String,
              let employeeId = json["employeeId"] as? Int,
              let issueId = json["issueId"] as? Int,
              let hourCount = json["hourCount"] as? Int else {
            return nil
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        guard let date = dateFormatter.date(from: dateString) else {
            return nil
        }
        return LaborCost(id: id, date: date, employeeId: employeeId, issueId: issueId, hourCount: hourCount)
    }
}
