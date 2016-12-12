//
//  Category.swift
//  Calculator
//
//  Created by Brandon Phan on 12/10/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

public class Category {
    
    public var name: String!
    public var image: UIImage!
    
    public func getImage() -> UIImage {
        return image
    }
    
    public func getName() -> String {
        return name
    }
}
