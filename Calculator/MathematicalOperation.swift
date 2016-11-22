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
//    @NSManaged var result: Double
//    @NSManaged var operation: [String]?
//
//    convenience public init(result: Double, operation: [String], context: NSManagedObjectContext) {
//        let entity = NSEntityDescription.entity(forEntityName: "OperationHistory", in: context)!
//        self.init(entity: entity, insertInto: context)
//
//        self.result = result
//        self.operation = operation
//    }
//
//    public func getResult() -> Double {
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
    
    var result: Float32
    var operation: [String]?
    
    public init(result: Float32, operation: [String]) {
        self.result = result
        self.operation = operation
    }
    
    public func getResult() -> Float32 {
        return result
    }
    
    public func getOperation() -> [String] {
        return operation!
    }
    
    
}
