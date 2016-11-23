

//
//  CalculatorUITests.swift
//  CalculatorUITests
//
//  Created by Brandon Phan on 7/23/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import XCTest

class CalculatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        let button = app.buttons["3"]
        button.tap()
        
        let button2 = app.buttons["+"]
        button2.tap()
        
        let button3 = app.buttons["5"]
        button3.tap()
        
        let button4 = app.buttons["＝"]
        button4.tap()
        
        let cButton = app.buttons["C"]
        cButton.press(forDuration: 1.0);
        
        let button5 = app.buttons["6"]
        button5.tap()
        
        let button6 = app.buttons["−"]
        button6.tap()
        
        let button7 = app.buttons["9"]
        button7.tap()
        button4.tap()
        
        let button8 = app.buttons["÷"]
        button8.tap()
        button7.tap()
        button3.tap()
        button4.tap()
        cButton.press(forDuration: 0.8);
        button7.tap()
        button3.tap()
        
        let button9 = app.buttons["2"]
        button9.tap()
        app.buttons["4"].tap()
        button3.tap()
        button.tap()
        button3.tap()
        app.buttons["8"].tap()
        button8.tap()
        button3.tap()
        button5.tap()
        button4.tap()
        cButton.press(forDuration: 0.9);
        button3.tap()
        button.tap()
        button6.tap()
        button9.tap()
        button4.tap()
        cButton.press(forDuration: 1.1);
        button9.tap()
        button.tap()
        button2.tap()
        button5.tap()
        button3.tap()
        button4.tap()
        cButton.press(forDuration: 0.8);
        cButton.press(forDuration: 1.0);
        button3.tap()
        button7.tap()
        app.buttons["×"].tap()
        button9.tap()
        app.buttons["7"].tap()
        button5.tap()
        button4.tap()
        cButton.press(forDuration: 0.9);
    }
    
}
