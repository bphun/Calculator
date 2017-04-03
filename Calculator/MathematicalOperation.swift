//
//  Operation.swift
//  Calculator
//
//  Created by Brandon Phan on 10/29/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import CoreData

//class MathematicalOperation: NSManagedObject {
//
//    @NSManaged var result: Float64
//    @NSManaged var operandStack: [String]?
//
//    convenience public init(result: Float64, operandStack: [String], context: NSManagedObjectContext) {
//        let entity = NSEntityDescription.entity(forEntityName: "OperationHistory", in: context)!
//        self.init(entity: entity, insertInto: context)
//
//        self.result = result
//        self.operandStack = operandStack
//    }
//
//    public func getResult() -> Float64 {
//        return result
//    }
//
//    public func getOperandStack() -> [String] {
//        return operandStack!
//    }
//}

class MathematicalOperation {
    
    private var result: Float64
    private var operandStack: [String]?
    
    public init(result: Float64, operandStack: [String]) {
        self.result = result
        self.operandStack = operandStack
    }
    
    public func getResult() -> Float64 {
        return result
    }
    
    public func getOperandStack() -> [String] {
        return operandStack!
    }
}
