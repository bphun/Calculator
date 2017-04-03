//
//  Extensions.swift
//  Calculator
//
//  Created by Brandon Phan on 12/23/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hex: Int) {
        self.init(red:(hex >> 16) & 0xff, green:(hex >> 8) & 0xff, blue:hex & 0xff)
    }
}

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
