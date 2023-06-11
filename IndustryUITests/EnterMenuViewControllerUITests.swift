//
//  EnterMenuViewControllerUITests.swift
//  IndustryUITests
//
//  Created by  Даниил on 11.06.2023.
//
import XCTest

class EnterMenuViewControllerUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
    }
    
    func launchAppWithLocale(_ locale: String, _ region: String) {
        app.launchArguments += ["-AppleLanguages", "(\(locale))", "-AppleLocale", "\(region)"]
        app.launch()
        sleep(5)
    }
    
    func testUIElementsExist_RU() throws {
        launchAppWithLocale("ru", "ru_RU")
        checkUIElementsExist()
    }
    
    func testUIElementsExist_EN() throws {
        launchAppWithLocale("en", "en_US")
        checkUIElementsExist()
    }
    
    private func checkUIElementsExist() {
        let btnEnter = app.buttons["btnEnter"]
        XCTAssertTrue(btnEnter.exists, "Enter button does not exist")
        
        // ... other checks here
    }

    func testButtonActions_RU() throws {
        launchAppWithLocale("ru", "ru_RU")
        performButtonActions()
    }
    
    func testButtonActions_EN() throws {
        launchAppWithLocale("en", "en_US")
        performButtonActions()
    }
    
    private func performButtonActions() {
        let btnEnter = app.buttons["btnEnter"]
        btnEnter.tap()
        
        // ... other button actions here
    }

    func testRecoveryPassButtonTapped_RU() {
        launchAppWithLocale("ru", "ru_RU")
        checkRecoveryPassButtonTapped()
    }
    
    func testRecoveryPassButtonTapped_EN() {
        launchAppWithLocale("en", "en_US")
        checkRecoveryPassButtonTapped()
    }
    
    private func checkRecoveryPassButtonTapped() {
        let recoveryPassButton = app.buttons["btnRecoveryPass"]
        XCTAssertTrue(recoveryPassButton.exists)
        recoveryPassButton.tap()
        let recoveryPasswordView = app.otherElements["RecovoryPasswordViewController"]
        XCTAssertTrue(recoveryPasswordView.exists)
    }

    func testNoInputValidation_RU() {
        launchAppWithLocale("ru", "ru_RU")
        checkNoInputValidation()
    }
    
    func testNoInputValidation_EN() {
        launchAppWithLocale("en", "en_US")
        checkNoInputValidation()
    }
    
    private func checkNoInputValidation() {
        let enterButton = app.buttons["btnEnter"]
        XCTAssertTrue(enterButton.exists)
        enterButton.tap()
        let alertTitleKey = localizedString("Ошибка")
        let alert = app.alerts[alertTitleKey]
        XCTAssertTrue(alert.exists)
    }

    func testDeviceCodeButtonTapped_RU() {
        launchAppWithLocale("ru", "ru_RU")
        checkDeviceCodeButtonTapped(isRu: true)
    }
    
    func testDeviceCodeButtonTapped_EN() {
        launchAppWithLocale("en", "en_US")
        checkDeviceCodeButtonTapped(isRu: false)
    }
    
    private func checkDeviceCodeButtonTapped(isRu: Bool) {
        let showCodeButton = app.buttons["btnShowCode"]
        XCTAssertTrue(showCodeButton.exists)
        showCodeButton.tap()
        var alertTitleKey = ""
        if isRu {
            alertTitleKey = "Ваш код устройства"
        } else {
            alertTitleKey = localizedString("Ваш код устройства")
        }
        let alert = app.alerts[alertTitleKey]
        XCTAssertTrue(alert.exists)
    }
    
    private func localizedString(_ key: String) -> String {
        let testBundle = Bundle(for: type(of: self))
        return NSLocalizedString(key, bundle: testBundle, comment: "")
    }
}


