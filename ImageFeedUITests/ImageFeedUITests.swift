//
//  ImageFeedUITests.swift
//  ImageFeedUITests
//
//  Created by Сергей Петров on 16.04.2026.
//

import XCTest

class Image_FeedUITests: XCTestCase {
    private let app = XCUIApplication()
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        
        app.launch()
    }
    
    func testAuth() throws {
        let authButton = app.buttons["Войти"]
        XCTAssertTrue(authButton.waitForExistence(timeout: 15))
        authButton.tap()
        
        let webView = app.webViews["UnsplashWebView"]
        XCTAssertTrue(webView.waitForExistence(timeout: 15))
        
        
        if app.toolbars.buttons["Done"].exists {
            app.toolbars.buttons["Done"].tap()
        }
        
        let loginTextField = webView.textFields.element
        XCTAssertTrue(loginTextField.waitForExistence(timeout: 5))
        loginTextField.tap()
        
        loginTextField.tap()
        loginTextField.typeText("spx3@ya.ru")
        webView.swipeUp()
        
        let passwordTextField = webView.descendants(matching: .secureTextField).element
        XCTAssertTrue(passwordTextField.waitForExistence(timeout: 15))
        
        passwordTextField.tap()
        passwordTextField.typeText("spx90909")
        webView.swipeUp()
        
        webView.buttons["Login"].tap()
        
        let tablesQuery = app.tables
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        
        XCTAssertTrue(cell.waitForExistence(timeout: 15))
    }
    
    func testFeed() throws {
        let tablesQuery = app.tables
        
        let cell = tablesQuery.children(matching: .cell).element(boundBy: 0)
        cell.swipeUp()
        
        sleep(2)
        
        let cellToLike = tablesQuery.children(matching: .cell).element(boundBy: 1)
        
        cellToLike.buttons["likeButton"].tap()
        
        sleep(3)
        
        cellToLike.buttons["likeButton"].tap()
        
        sleep(3)
        
        cellToLike.tap()
        
        sleep(3)
        
        let image = app.scrollViews.images.element(boundBy: 0)
        // Zoom in
        image.pinch(withScale: 3, velocity: 1) // zoom in
        // Zoom out
        image.pinch(withScale: 0.5, velocity: -1)
        
        let navBackButtonWhiteButton = app.buttons["BackwardButton"]
        navBackButtonWhiteButton.tap()
    }
    
    func testProfile() throws {
        sleep(3)
        app.tabBars.buttons.element(boundBy: 1).tap()
        sleep(3)
       
        XCTAssertTrue(app.staticTexts["Name Lastname"].exists)
        XCTAssertTrue(app.staticTexts["@username"].exists)
        sleep(3)
        app.buttons["logoutButton"].tap()
        sleep(3)
        app.alerts["Пока пока!"].scrollViews.otherElements.buttons["Да"].tap()
    }
}
