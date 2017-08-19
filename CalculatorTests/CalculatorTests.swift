//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Brandon Phan on 8/18/17.
//  Copyright © 2017 Brandon Phan. All rights reserved.
//

import XCTest

class CalculatorTests: XCTestCase {
	
	var calculator: Calculator!
	
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
		calculator = Calculator()
	}
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
	func calculate() -> Double {
		var operandStack = ["10","*","11"]
		var result = 0.0
		
		guard operandStack[2] != "" else { return Double(operandStack[0])! }
		
		while operandStack.count >= 3 {
			
			calculator.setOperand(operand: Double(operandStack[0])!)
			calculator.performOperation(symbol: String(operandStack[1]))
			calculator.setOperand(operand: Double(operandStack[2])!)
			calculator.performOperation(symbol: String(operandStack[1]))
			
			result = calculator.result
			
			for _ in 0..<3 {
				operandStack.remove(at: 0)
			}
//			operandStack.removeFirst(3)
			
			if operandStack.count == 0 {
				return result
			} else if operandStack.count >= 2 {
				calculator.clear()
				operandStack.append(String(format: "%.0f", result))
				operandStack = operandStack.shiftedRight()
			}
		}
		
		calculator.clear()
		operandStack.removeAll()
		return result
	}
	
    func calculatePerformancetest() {
        // This is an example of a performance test case.
        self.measure {
		   print(calculate())
        }
    }
    
}

extension Array {
	func shiftedLeft(by rawOffset: Int = 1) -> Array {
		let clampedAmount = rawOffset % count
		let offset = clampedAmount < 0 ? count + clampedAmount : clampedAmount
		return Array(self[offset ..< count] + self[0 ..< offset])
	}
	
	func shiftedRight(by rawOffset: Int = 1) -> Array {
		return self.shiftedLeft(by: -rawOffset)
	}
	
	mutating func shiftLeft(by rawOffset: Int = 1) {
		self = self.shiftedLeft(by: rawOffset)
	}
	
	mutating func shiftRight(by rawOffset: Int = 1) {
		self = self.shiftedRight(by: rawOffset)
	}
}
