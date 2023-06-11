import XCTest

class IndustryAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
        
    }

    override func tearDown() {
        app = nil
        super.tearDown()
    }
    
    func waitForElementToExist(element: XCUIElement, timeout: TimeInterval = 5) {
        let existsPredicate = NSPredicate(format: "exists == true")
        expectation(for: existsPredicate, evaluatedWith: element, handler: nil)

        waitForExpectations(timeout: timeout) { (error) in
            if let error = error {
                XCTFail("waitForElementToExist failed: \(error)")
            }
        }
    }

    
    func testGreetingExists() {
        let greetingLabel = app.staticTexts["lblGreeting"]
        waitForElementToExist(element: greetingLabel, timeout: 3)
    }
    
    func testTransitionToEnterMenuViewController() {
        // Добавляем launchArguments и перезапускаем приложение
        app.terminate()
        app.launchArguments += ["-resetUser", "YES"]
        app.launch()

        let enterButton = app.buttons["btnEnter"]
        waitForElementToExist(element: enterButton, timeout: 5)

        // Удаляем launchArguments для следующих тестов
        app.terminate()
        if let idx = app.launchArguments.firstIndex(of: "-resetUser") {
            app.launchArguments.remove(at: idx)
        }
        app.launch()
    }

    
    func testUIElementsExist() {
        let enterButton = app.buttons["btnEnter"]
        let recoverPasswordButton = app.buttons["btnRecoveryPass"]
        let logoImage = app.images["imgCompany"]
        let tableView = app.tables.element(boundBy: 0)
        
        waitForElementToExist(element: enterButton)
        waitForElementToExist(element: recoverPasswordButton)
        waitForElementToExist(element: logoImage)
        waitForElementToExist(element: tableView)
    }
    
    func testEnterButtonClick() {
        let enterButton = app.buttons["btnEnter"]
        waitForElementToExist(element: enterButton)
        enterButton.tap()
        // Здесь вы можете добавить проверки, чтобы убедиться, что приложение перешло на следующий экран
    }
    func testRecovoryPasswordViewControllerUIElementsExist() {
        let btnEnter = app.buttons["btnEnter"]
        let btnRecovoryPass = app.buttons["btnRecoveryPass"]
        let collectionView = app.collectionViews["collRecovery"]
        let companyLogo = app.images["imgCompany"]
        let backButton = app.navigationBars.buttons["btnBack"]

        waitForElementToExist(element: btnEnter, timeout: 10)
        waitForElementToExist(element: btnRecovoryPass, timeout: 10)
        btnRecovoryPass.tap() // navigate to the RecovoryPasswordViewController
        waitForElementToExist(element: collectionView, timeout: 10)
        waitForElementToExist(element: companyLogo, timeout: 10)
        waitForElementToExist(element: backButton, timeout: 10)
    }

    func testBackButtonClick() {
        let btnEnter = app.buttons["btnEnter"]
        let btnRecovoryPass = app.buttons["btnRecoveryPass"]
        let backButton = app.navigationBars.buttons["btnBack"]

        waitForElementToExist(element: btnEnter, timeout: 10)
        btnRecovoryPass.tap() // navigate to the RecovoryPasswordViewController
        waitForElementToExist(element: backButton, timeout: 10)
        backButton.tap()
        waitForElementToExist(element: btnEnter, timeout: 10)
    }

}
