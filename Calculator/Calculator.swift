//
//  Calculator.swift
//  Calculator
//
//  Created by Brandon Phan on 7/24/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation

protocol CalculatorProtocol {
    func evaluate() -> (Float32, String)
    func correctSemantics() -> Bool
}

class Calculator: CalculatorProtocol {
    
    private var operandStack = [String]()
    
    public init(operandStack: [String]) {
        self.operandStack = operandStack
    }
    
    public func evaluate() -> (Float32, String) {
        print("OperandStack: \(operandStack)")
//        var (result, error) = (Float32(), String())
        
        var result: Float32 = 0.0
        var error = ""
        if (!correctSemantics()) {
            error = "  ERROR"
            return (0, error)
        }
        
        let op1 = Float32(self.operandStack[0])!
        let op2 = Float32(self.operandStack[2])!
        let operand = self.operandStack[1]

        switch operand {
        case "×":
            result = op1 * op2
            break
        case "÷":
            result = op1 / op2
            break
        case "+":
            result = op1 + op2
            break;
        case "-":
            result = op1 - op2
            break
        default:
            break
        }
        print(op1 - op2)


        for _ in 0..<3 {
            self.operandStack.remove(at: 0)
        }
        
        if self.operandStack.count > 0 && self.operandStack.count % 2 == 0 {
            self.operandStack.append(String(format: "%.1f", result))
            self.operandStack = self.operandStack.shiftedRight()
            
            (result,_) = self.evaluate()
        }

        self.operandStack.removeAll()
        print("Result: \(result) \n")
        return (result, error)
    }
    
    internal func correctSemantics() -> Bool {
        
        let numbers: [Character] = ["1", "2","3","4","5","6","7","8","9","0"]
        let ops = ["(",")","÷","×","−","+"]
        
        if operandStack[0] != "" && numbers.contains(operandStack[0].characters.first!) {
            if operandStack[1] != "" && ops.contains(operandStack[1]) {
                if operandStack[2] != "" && numbers.contains(operandStack[2].characters.first!) {
                    return true
                }
            }
        }
        return false
    }
    
}
