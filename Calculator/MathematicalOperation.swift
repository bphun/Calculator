//
//  MathematicalOperation.swift
//  Calculator
//
//  Created by Brandon Phan on 10/29/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import CoreData

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

//class MathematicalOperation: NSManagedObject {
//
//	@NSManaged private var result: Float64
//	@NSManaged private var operandStack: [String]?
//
//	public init(result: Float64, operandStack: [String], context: NSManagedObjectContext) {
//		let entity = NSEntityDescription.entity(forEntityName: "MathematicalOperation", in: context)!
//		super.init(entity: entity, insertInto: context)
//
//		self.result = result
//		self.operandStack = operandStack
//	}
//
//	public func getResult() -> Float64 {
//		return result
//	}
//
//	//	public func operandStack() -> [String] {
//	//		return operandStack!
//	//	}
//}

