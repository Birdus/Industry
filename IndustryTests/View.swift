import XCTest

class SplachViewControllerTests: XCTestCase {
    
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
}
