//
//  Calculator.swift
//  Calculator
//
//  Created by Brandon Phan on 7/24/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation

class Calculator {
    
    private let formatter: NumberFormatter = {
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
    
//    var description: String {
//        get {
//            if pending == nil {
//                return descriptionAccumulator
//            } else {
//                return pending!.descriptionFunction(pending!.descriptionOperand, pending!.descriptionOperand != descriptionAccumulator ? descriptionAccumulator : "")
//            }
//        }
//    }
	
//    var isPartialResult: Bool {
//        get {
//            return pending != nil
//        }
//    }
		
    
    func setOperand(operand: Double) {
        accumulator = operand
        descriptionAccumulator = formatter.string(from: NSNumber(value: accumulator)) ?? ""
        internalProgram.append(operand as AnyObject)
    }
    
    private enum OperationType {
        case NullaryOperation(() -> Double,String)
        case Constant(Double)
        case UnaryOperation((Double) -> Double,(String) -> String)
        case BinaryOperation((Double, Double) -> Double, (String, String) -> String, Int)
        case Equals
    }
    
    private var operations: [String : OperationType] = [
        "rand": OperationType.NullaryOperation(drand48, "rand()"),
        "π": OperationType.Constant(Double.pi),
        "e": OperationType.Constant(M_E),
        "±": OperationType.UnaryOperation({ -$0 }, { "±(" + $0 + ")"}),
        "√": OperationType.UnaryOperation(sqrt, { "√(" + $0 + ")"}),
        "cos": OperationType.UnaryOperation(cos,{ "cos(" + $0 + ")"}),
        "sin": OperationType.UnaryOperation(sin,{ "sin(" + $0 + ")"}),
        "tan": OperationType.UnaryOperation(tan,{ "tan(" + $0 + ")"}),
        "sin⁻¹": OperationType.UnaryOperation(asin, { "sin⁻¹(" + $0 + ")"}),
        "cos⁻¹": OperationType.UnaryOperation(acos, { "cos⁻¹(" + $0 + ")"}),
        "tan⁻¹": OperationType.UnaryOperation(atan, { "tan⁻¹(" + $0 + ")"}),
        "ln": OperationType.UnaryOperation(log, { "ln(" + $0 + ")"}),
        "x⁻¹": OperationType.UnaryOperation({ 1.0 / $0}, {"(" + $0 + ")⁻¹"}),
        "х²": OperationType.UnaryOperation({$0 * $0}, { "(" + $0 + ")²"}),
        "×": OperationType.BinaryOperation(*, { $0 + " × " + $1 }, 1),
        "÷": OperationType.BinaryOperation(/, { $0 + " ÷ " + $1 }, 1),
        "+": OperationType.BinaryOperation(+, { $0 + " + " + $1 }, 0),
        "−": OperationType.BinaryOperation(-, { $0 + "-" + $1 }, 0),
        "xʸ" : OperationType.BinaryOperation(pow, { $0 + " ^ " + $1 }, 2),
        "=": OperationType.Equals
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
    
//    typealias PropertyList = AnyObject
	
//    var program: PropertyList {
//        get {
//            return internalProgram as Calculator.PropertyList
//        } set {
//            clear()
//            if let arrayOfOps = newValue as? [AnyObject] {
//                for op in arrayOfOps {
//                    if let operand = op as? Double {
//                        setOperand(operand: operand)
//                    } else if let operation = op as? String {
//                        performOperation(symbol: operation)
//                    }
//                }
//            }
//        }
//    }
	
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

