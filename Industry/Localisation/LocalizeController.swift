//
//  LocalizeController.swift
//  Industry
//
//  Created by Даниил on 08.03.2023.
//

import Foundation

// MARK: - Localized String Extension
extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}
// This extension provides a computed property localized on String data type. This property returns a localized version of the string using the default localization table and bundle. The NSLocalizedString function is used to provide a localized version of the string. The comment parameter is optional and is used to provide context for the translator.
