import XCTest

class IndustryAppUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launch()
    }
    
    func testGreetingExists() {
        let greetingLabel = app.staticTexts["lblGreeting"]
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: greetingLabel, handler: nil)
        waitForExpectations(timeout: 3, handler: nil)
        
        XCTAssertTrue(greetingLabel.exists, "Greeting label doesn't exist.")
    }
    
    func testTransitionToEnterMenuViewController() {
        let enterButton = app.buttons["btnEnter"]
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: enterButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(enterButton.exists, "Enter button doesn't exist.")
    }
    
    func testUIElementsExist() {
        let enterButton = app.buttons["btnEnter"]
        let recoverPasswordButton = app.buttons["btnRecoveryPass"]
        let logoImage = app.images["imgCompany"]
        let tableView = app.tables.element(boundBy: 0)
        
        // Поскольку есть задержка перед появлением EnterMenuViewController, нужно добавить ожидание
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: enterButton, handler: nil)
        expectation(for: exists, evaluatedWith: recoverPasswordButton, handler: nil)
        expectation(for: exists, evaluatedWith: logoImage, handler: nil)
        expectation(for: exists, evaluatedWith: tableView, handler: nil)
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertTrue(enterButton.exists, "Enter button doesn't exist.")
        XCTAssertTrue(recoverPasswordButton.exists, "Recover Password button doesn't exist.")
        XCTAssertTrue(logoImage.exists, "Logo image doesn't exist.")
        XCTAssertTrue(tableView.exists, "Authentication table doesn't exist.")
    }
    
    func testEnterButtonClick() {
        let enterButton = app.buttons["btnEnter"]
        
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: enterButton, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        
        enterButton.tap()
        // Здесь вы можете добавить проверки, чтобы убедиться, что приложение перешло на следующий экран
        // Например, вы можете проверить, что на следующем экране присутствует определенный элемент
    }
    
    func testRecovoryPasswordViewControllerUIElementsExist() {
        let btnEnter = app.buttons["btnEnter"]
        let btnRecovoryPass = app.buttons["btnRecoveryPass"]
        let collectionView = app.collectionViews["collRecovery"]
        let companyLogo = app.images["imgCompany"]
        let backButton = app.navigationBars.buttons["btnBack"]
        
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: btnEnter, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        expectation(for: exists, evaluatedWith: btnRecovoryPass, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        btnRecovoryPass.tap() // navigate to the RecovoryPasswordViewController
        expectation(for: exists, evaluatedWith: collectionView, handler: nil)
        expectation(for: exists, evaluatedWith: companyLogo, handler: nil)
        expectation(for: exists, evaluatedWith: backButton, handler: nil)
        waitForExpectations(timeout: 7, handler: nil)
        XCTAssertTrue(collectionView.exists, "Recovery options collection view doesn't exist.")
        XCTAssertTrue(companyLogo.exists, "Company logo doesn't exist.")
        XCTAssertTrue(backButton.exists, "Back button doesn't exist.")
    }


    
    func testBackButtonClick() {
        let btnEnter = app.buttons["btnEnter"]
        let btnRecovoryPass = app.buttons["btnRecoveryPass"]
        let collectionView = app.collectionViews["collRecovery"]
        let companyLogo = app.images["imgCompany"]
        let backButton = app.navigationBars.buttons["btnBack"]
        
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: btnEnter, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        expectation(for: exists, evaluatedWith: btnRecovoryPass, handler: nil)
        waitForExpectations(timeout: 5, handler: nil)
        btnRecovoryPass.tap() // navigate to the RecovoryPasswordViewController
        expectation(for: exists, evaluatedWith: collectionView, handler: nil)
        expectation(for: exists, evaluatedWith: companyLogo, handler: nil)
        expectation(for: exists, evaluatedWith: backButton, handler: nil)
        waitForExpectations(timeout: 7, handler: nil)
        backButton.tap()
        XCTAssertTrue(btnEnter.exists, "Enter button doesn't exist.")
    }
}
