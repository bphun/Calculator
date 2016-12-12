//
//  UnitConverter.swift
//  Calculator
//
//  Created by Brandon Phan on 12/10/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

class UnitConverter {
    
    private let categories = [Acceleration(), Density()]
    
    public func getCategories() -> [Category] {
        return categories
    }
    
}
