//
//  RecovoryPasswordInfo.swift
//  Industry
//
//  Created by  Даниил on 07.06.2023.
//

import Foundation

enum RecovoryPasswordInfo {
    case mail(value: String)
    case acssesCode(value: Int)
    case error(messege: String)
}
