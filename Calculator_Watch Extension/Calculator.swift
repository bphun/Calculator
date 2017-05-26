//
//  Calculator.swift
//  Calculator
//
//  Created by Brandon Phan on 7/24/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation

class Calculator {
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.notANumberSymbol = "  ERROR"
        formatter.groupingSeparator = " "
        formatter.locale = NSLocale.current
        return formatter
        
    }()
    
    private var internalProgram = [AnyObject]()
    private var accumulator = 0.0
    
    var result: Double {
        get {
            return accumulator
        }
    }
    
    private var currentPrecedence = Int.max
    private var descriptionAccumulator = "0" {
        didSet {
            if pending == nil {
                currentPrecedence = Int.max
            }
        }
    }
    
    var description: String {
        get {
            if pending == nil {
                return descriptionAccumulator
            } else {
                return pending!.descriptionFunction(pending!.descriptionOperand, pending!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "")
            }
        }
    }
    
    var isPartialResult: Bool {
        get {
            return pending != nil
        }
    }
    
    
    func setOperand(operand: Double) {
        accumulator = operand
        descriptionAccumulator = formatter.string(from: NSNumber(value: accumulator)) ?? ""
        internalProgram.append(operand as AnyObject)
    }
    
    private enum Operation {
        case NullaryOperation(() -> Double,String)
        case Constant(Double)
        case UnaryOperation((Double) -> Double,(String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String, Int)
        case Equals
    }
    
    private var operations: [String: Operation] = [
        "rand": Operation.NullaryOperation(drand48, "rand()"),
        "π": Operation.Constant(Double.pi),
        "e": Operation.Constant(M_E),
        "±": Operation.UnaryOperation({ -$0 }, { "±(" + $0 + ")"}),
        "√": Operation.UnaryOperation(sqrt, { "√(" + $0 + ")"}),
        "cos": Operation.UnaryOperation(cos,{ "cos(" + $0 + ")"}),
        "sin": Operation.UnaryOperation(sin,{ "sin(" + $0 + ")"}),
        "tan": Operation.UnaryOperation(tan,{ "tan(" + $0 + ")"}),
        "sin⁻¹": Operation.UnaryOperation(asin, { "sin⁻¹(" + $0 + ")"}),
        "cos⁻¹": Operation.UnaryOperation(acos, { "cos⁻¹(" + $0 + ")"}),
        "tan⁻¹": Operation.UnaryOperation(atan, { "tan⁻¹(" + $0 + ")"}),
        "ln": Operation.UnaryOperation(log, { "ln(" + $0 + ")"}),
        "x⁻¹": Operation.UnaryOperation({ 1.0 / $0}, {"(" + $0 + ")⁻¹"}),
        "х²": Operation.UnaryOperation({$0 * $0}, { "(" + $0 + ")²"}),
        "×": Operation.BinaryOperation(*, { $0 + " × " + $1 }, 1),
        "÷": Operation.BinaryOperation(/, { $0 + " ÷ " + $1 }, 1),
        "+": Operation.BinaryOperation(+, { $0 + " + " + $1 }, 0),
        "−": Operation.BinaryOperation(-, { $0 + "-" + $1 }, 0),
        "xʸ" : Operation.BinaryOperation(pow, { $0 + " ^ " + $1 }, 2),
        "=": Operation.Equals
    ]
    
    func performOperation(symbol: String) {
        internalProgram.append(symbol as AnyObject)
        if let operation = operations[symbol] {
            switch operation {
            case .NullaryOperation(let function, let descriptionValue):
                accumulator = function()
                descriptionAccumulator = descriptionValue
                
            case .Constant(let value):
                accumulator = value
                descriptionAccumulator = symbol
                
            case .UnaryOperation(let function, let descriptionFunction):
                accumulator = function(accumulator)
                descriptionAccumulator = descriptionFunction(descriptionAccumulator)
                
            case .BinaryOperation(let function, let descriptionFunction, let precedence):
                executeBinaryOperation()
                if currentPrecedence < precedence {
                    descriptionAccumulator = "(" + descriptionAccumulator + ")"
                }
                currentPrecedence = precedence
                pending = PendingBinaryOperationInfo(binaryOperation: function, firstOperand: accumulator, descriptionFunction: descriptionFunction, descriptionOperand: descriptionAccumulator)
                
            case .Equals:
                executeBinaryOperation()
                
            }
        }
    }
    
    private func executeBinaryOperation() {
        
        if pending != nil{
            accumulator = pending!.binaryOperation(pending!.firstOperand, accumulator)
            descriptionAccumulator = pending!.descriptionFunction(pending!.descriptionOperand, descriptionAccumulator)
            pending = nil
        }
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {
        get {
            return internalProgram as Calculator.PropertyList
        } set {
            clear()
            if let arrayOfOps = newValue as? [AnyObject] {
                for op in arrayOfOps {
                    if let operand = op as? Double {
                        setOperand(operand: operand)
                    } else if let operation = op as? String {
                        performOperation(symbol: operation)
                    }
                }
            }
        }
    }
    
    func clear() {
        accumulator = 0.0
        pending = nil
        descriptionAccumulator = " "
        currentPrecedence = Int.max
    }
    
    private var pending: PendingBinaryOperationInfo?
    
    private struct PendingBinaryOperationInfo {
        var binaryOperation: (Double, Double) ->Double
        var firstOperand: Double
        var descriptionFunction: (String, String) -> String
        var descriptionOperand: String
    }
    
}

