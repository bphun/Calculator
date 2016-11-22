//
//  Extensions.swift
//  Calculator
//
//  Created by Brandon Phan on 7/25/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    func shiftedLeft(by rawOffset: Int = 1) -> Array {
        let clampedAmount = rawOffset % count
        let offset = clampedAmount < 0 ? count + clampedAmount : clampedAmount
        return Array(self[offset ..< count] + self[0 ..< offset])
    }
    
    func shiftedRight(by rawOffset: Int = 1) -> Array {
        return self.shiftedLeft(by: -rawOffset)
    }
    
    mutating func shiftLeft(by rawOffset: Int = 1) {
        self = self.shiftedLeft(by: rawOffset)
    }
    
    mutating func shiftRight(by rawOffset: Int = 1) {
        self = self.shiftedRight(by: rawOffset)
    }
}

extension String {
    
    func removeCharacterInString(string: String, Characters: String) -> String {
        return string.replacingOccurrences(of: Characters, with: "")
    }
    
    func indexOf(string: String) -> String.Index? {
        return range(of: string, options: .literal, range: nil, locale: nil)?.lowerBound
    }
}

//extension Float80 {
//    var cleanValue: String {
//        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self as! CVarArg) : String(self)
//    }
//
//}



