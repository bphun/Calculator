//
//  Operation.swift
//  Calculator
//
//  Created by Brandon Phan on 10/29/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation

class MathematicalOperation {
    
    private var result: Double
    private var operandStack: [String]!

    public init(result: Double, operandStack: [String]) {
        self.result = result
        self.operandStack = operandStack
    }
    
    public func getResult() -> Double {
        return result
    }
    
    public func getOperation() -> [String] {
        return operandStack
    }
    
    
}
