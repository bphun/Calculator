//
//  Operation.swift
//  Calculator
//
//  Created by Brandon Phan on 10/29/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import CoreData

//@objc class MathematicalOperation: NSManagedObject {
//
//    @NSManaged var result: Float64
//    @NSManaged var operation: [String]?
//
//    convenience public init(result: Float64, operation: [String], context: NSManagedObjectContext) {
//        let entity = NSEntityDescription.entity(forEntityName: "OperationHistory", in: context)!
//        self.init(entity: entity, insertInto: context)
//
//        self.result = result
//        self.operation = operation
//    }
//
//    public func getResult() -> Float64 {
//        return result
//    }
//
//    public func getOperation() -> [String] {
//        return operation!
//    }
//
//
//}

class MathematicalOperation {
    
    var result: Float64
    var operation: [String]?
    
    public init(result: Float64, operation: [String]) {
        self.result = result
        self.operation = operation
    }
    
    public func getResult() -> Float64 {
        return result
    }
    
    public func getOperation() -> [String] {
        return operation!
    }
    
    
}
