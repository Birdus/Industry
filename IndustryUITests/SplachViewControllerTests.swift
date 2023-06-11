//
//  SplachViewControllerTests.swift
//  IndustryUITests
//
//  Created by  Даниил on 11.06.2023.
//

import XCTest

class SplachViewControllerTests: XCTestCase {

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func launchAppWithLocale(_ locale: String, _ region: String) {
        app.launchArguments += ["-AppleLanguages", "(\(locale))", "-AppleLocale", "\(region)"]
        app.launch()
    }
    
    func testUIElementsExist_RU() throws {
        launchAppWithLocale("ru", "ru_RU")
        greetingLabelExist(isRu: true)
    }
    
    func testUIElementsExist_EN() throws {
        launchAppWithLocale("en", "en_US")
        greetingLabelExist(isRu: false)
    }

    private func greetingLabelExist(isRu: Bool) {
        // Given
        var txt = ""
        if isRu {
            txt = "Добро пожаловать!"
        } else {
            txt = localizedString("Добро пожаловать!")
        }
        let greetingLabel = app.staticTexts["lblGreeting"]
        // Then
        XCTAssertTrue(greetingLabel.exists, txt)
    }
    
    func testGreetingLabelText_RU() throws {
        launchAppWithLocale("ru", "ru_RU")
        greetingLabelText(isRu: true)
    }
    
    func testGreetingLabelText_EN() throws {
        launchAppWithLocale("en", "en_US")
        greetingLabelText(isRu: false)
    }

    private func greetingLabelText(isRu: Bool) {
        // Given
        let greetingLabel = app.staticTexts["lblGreeting"]
        var txt = ""
        if isRu {
            txt = "Добро пожаловать!"
        } else {
            txt = localizedString("Добро пожаловать!")
        }
        XCTAssertTrue(greetingLabel.isHittable, txt)
    }
    
    private func localizedString(_ key: String) -> String {
        let testBundle = Bundle(for: type(of: self))
        return NSLocalizedString(key, bundle: testBundle, comment: "")
    }
}
