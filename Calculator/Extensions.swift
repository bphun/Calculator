//
//  Extensions.swift
//  Calculator
//
//  Created by Brandon Phan on 7/25/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation

extension Array {
    func shiftRight( amount: Int = 1) -> [Element] {
        var amount = amount
        assert(-count...count ~= amount, "Shift amount out of bounds")
        if amount < 0 { amount += count }  // this needs to be >= 0
        return Array(self[amount ..< count] + self[0 ..< amount])
    }
    
    mutating func shiftRightInPlace(amount: Int = 1) {
        self = shiftRight(amount: amount)
    }
}

extension String {
    
    func removeCharacterInString(string: String, Characters: String) -> String {
        return string.replacingOccurrences(of: Characters, with: "")
    }
    
}
