//
//  Calculator.swift
//  Calculator
//
//  Created by Brandon Phan on 7/24/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation

class Calculator {
    
    private var operandStack = [String]()
    
    public init(operandStack: [String]) {
        self.operandStack = operandStack
    }
    
    public func evaluate() -> Double {
        print("OperandStack: \(operandStack)")
        
        var result = Double()
        
        let op1 = Double(operandStack[0])
        let op2 = Double(operandStack[2])
        let operand = operandStack[1]
        
        switch operand {
        case "×":
            result = op1! * op2!
            break
        case "÷":
            result = op1! / op2!
            break
        case "+":
            result = op1! + op2!
            break;
        case "-":
            result = op1! - op2!
            break
        default:
            break
        }
        
        for _ in 0..<3 {
            operandStack.remove(at: 0)
        }
        
        if operandStack.count != 0 && operandStack.count % 2 == 0 {
            operandStack.append(String(format: "%.1f", result))
            operandStack = operandStack.shiftedRight()
            result = evaluate()
        }
        operandStack.removeAll()
        print("Result: \(result) \n")
        return result
    }
    
}
