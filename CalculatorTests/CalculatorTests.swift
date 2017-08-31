//
//  CalculatorTests.swift
//  CalculatorTests
//
//  Created by Brandon Phan on 8/20/17.
//  Copyright © 2017 Brandon Phan. All rights reserved.
//

import XCTest

class CalculatorTests: XCTestCase {
	
	private let TEST_MODE = 0
	
	private var calculator: Calculator!
	private var operandStack: [String]!
	
	private var prevOp: String!
	private var answerLabel: UILabel!
	private var opLabel: UILabel!
	private let CLEAR_TEXT = "  0"
	private let ERROR_STR = "  ERROR"
	
    override func setUp() {
        super.setUp()
		
		calculator = Calculator()

		switch TEST_MODE {
		case 0:
			operandStack = ["10","*","11"]
			break
		case 1:
			operandStack = ["10","*","11"]
			prevOp = ""
			answerLabel = UILabel()
			opLabel = UILabel()
			break
		default:
			break
		}
	}
    
    override func tearDown() {
        super.tearDown()
		
		calculator = nil
		
		switch TEST_MODE {
		case 0:
			operandStack = nil
			break
		case 1:
			prevOp = nil
			answerLabel = nil
			opLabel = nil
			operandStack = nil
		default:
			break
		}
		
	}
    
	func calculate() -> Double {
		var result = 0.0
		
		guard operandStack[2] != "" else { return Double(operandStack[0])! }
		
		while operandStack.count >= 3 {
			
			calculator.setOperand(operand: Double(operandStack[0])!)
			calculator.performOperation(symbol: String(operandStack[1]))
			calculator.setOperand(operand: Double(operandStack[2])!)
			calculator.performOperation(symbol: String(operandStack[1]))
			
			result = calculator.result
			
//			for _ in 0..<3 {
//				operandStack.remove(at: 0)
//			}
			operandStack.removeFirst(3)
			
//			if operandStack.count == 0 {
//				return result
//			} else if operandStack.count >= 2 {
//				calculator.clear()
//				operandStack.append(String(format: "%.0f", result))
//				operandStack = operandStack.shiftedRight()
//			}
			switch operandStack.count {
			case 0:
				return result
			default:
				calculator.clear()
				operandStack.append(String(format: "%.0f", result))
				operandStack = operandStack.shiftedRight()
				break
			}
		}
		
		calculator.clear()
		operandStack.removeAll()
		return result
	}
	
	func clearTextField() {
		if opLabel.text != CLEAR_TEXT || answerLabel.text == ERROR_STR {
			opLabel.text = CLEAR_TEXT
			answerLabel.text = "0"
			calculator.clear()
			operandStack.removeAll()
			prevOp = ""
		}
	}
	
	func testPerformance_calculate() {
		self.measure {
			XCTAssert(calculate() != 110, "Calculate returned incorrect value")
		}
	}
	
	func testPerformance_clearTextField() {
		self.measure {
			clearTextField()
		}
	}
    
}
