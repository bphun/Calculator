//
//  File.swift
//  Calculator
//
//  Created by Brandon Phan on 12/10/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

class UnitConversionViewController: UIViewController {
    
    private var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
 
    public func setCategory(category: Category) {
        self.category = category
    }
    
}
