//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Brandon Phan on 7/23/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import XCTest
@testable import Calculator

class CalculatorTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
            
            let operandStack = ["10", "+", "63.2"]
            let calculator = Calculator(operandStack: operandStack)
            let calculationResult = calculator.evaluate()
            print("Result: \(calculationResult)")
            
        }
    }
    
}
