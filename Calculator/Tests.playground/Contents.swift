//: Playground - noun: a place where people can play

import UIKit
import Foundation

let attributeGreen = [NSForegroundColorAttributeName: UIColor.green ]
let attributeWhite = [NSForegroundColorAttributeName: UIColor.white ]

let numbers = "3 + 3"
let ops = ["(",")","÷","×","−","+"]
let label = UILabel.init(frame: CGRect(x: 20, y: 20, width: 100, height: 30))

var mutableString = NSMutableAttributedString()

mutableString = NSMutableAttributedString(string: numbers, attributes: [NSFontAttributeName:UIFont(name: "Avenir Next", size: 18.0)!])

var index: String.Index!
let attributedString = NSMutableAttributedString()

//for i in 0..<numbers.characters.count {
//    index = numbers.index(numbers.startIndex, offsetBy: i)
//    if ops.contains(String(numbers[index])) {
//        break
//    }
//    
//    num += 1
//}


for i in 0..<numbers.characters.count {
    index = numbers.index(numbers.startIndex, offsetBy: i)
    if ops.contains(String(numbers[index])) {
        let attributedStringChar = NSAttributedString(string: String(numbers[index]), attributes: attributeGreen)
        attributedString.append(attributedStringChar)
    } else {
        let attributedStringChar = NSAttributedString(string: String(numbers[index]), attributes: attributeWhite)
        attributedString.append(attributedStringChar)
    }
}


//print(numbers[index])

//var range = NSRange.init(location: num, length: 0)
//
//
//let attributedString = NSMutableAttributedString(string: numbers)
//
//attributedString.addAttributes(attributeGreen, range: range)
//
//range = NSRange.init(location: num - 1, length: 0)
//attributedString.addAttributes(attriubteWhite, range: range)
//
//range = NSRange.init(location: num + 1, length: 0)
//attributedString.addAttributes(attriubteWhite, range: range)

label.attributedText = attributedString

