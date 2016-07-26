//
//  ViewController.swift
//  Calculator
//
//  Created by Brandon Phan on 7/23/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var openParenthesesButton: UIButton!
    @IBOutlet weak var closeParenthesesButton: UIButton!
    @IBOutlet weak var divideButton: UIButton!
    @IBOutlet weak var multiplyButton: UIButton!
    @IBOutlet weak var subtractButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var solveButton: UIButton!
    
    @IBOutlet weak var sevenButton: UIButton!
    @IBOutlet weak var eightButton: UIButton!
    @IBOutlet weak var nineButton: UIButton!
    @IBOutlet weak var fourButton: UIButton!
    @IBOutlet weak var fiveButton: UIButton!
    @IBOutlet weak var sixButton: UIButton!
    @IBOutlet weak var oneButton: UIButton!
    @IBOutlet weak var twoButton: UIButton!
    @IBOutlet weak var threeButton: UIButton!
    @IBOutlet weak var zeroButton: UIButton!
    @IBOutlet weak var decimalButton: UIButton!
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let clearButtonLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.clearButtonLongPress(recognizer:)))
        clearButtonLongPressGestureRecognizer.minimumPressDuration = 0.4
        
        let clearButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.clearButtonTap(recognizer:)))
        
        for button in buttonCollection {
            button.layer.borderWidth = 0.28
            button.layer.borderColor = UIColor.black().withAlphaComponent(0.5).cgColor
            button.addTarget(self, action: #selector(ViewController.appendCharacter(sender:)), for: .touchUpInside)
            
            if button.currentTitle == "C" {
                button.addGestureRecognizer(clearButtonLongPressGestureRecognizer)
                button.addGestureRecognizer(clearButtonTapGestureRecognizer)
            } else if button.currentTitle == "÷" || button.currentTitle == "×" || button.currentTitle == "−" || button.currentTitle == "+" {
                button.addTarget(self, action: #selector(ViewController.operatorTapped(sender:)), for: .touchUpInside)
            }
        }
    }
    
    func appendCharacter(sender: UIButton) {
        
        var character = (sender.currentTitle)!
        
        switch character {
            
        case "(":
            character = " ( "
            
        case ")":
            character = " ) "
            
        case "÷":
            character = " ÷ "
            
        case "×":
            character = " × "
            
        case "−":
            character = " − "
            
        case "+":
            character = " + "
            
        default:
            character = (sender.currentTitle)!
            operationLabel.textColor = UIColor.black()
        }
        
        if character != "C" && character != "=" {
            let labelText = operationLabel.text! + character
            operationLabel.text = labelText
        }
    }
    
    var operandStack = [String]()
    
//    var displayValue: Double {
//        
//        get {
//            return (NumberFormatter().number(from: operationLabel.text!)?.doubleValue)!
//            
//        } set {
//            operationLabel.text = "\(newValue)"
//        }
//        
//    }
    
    
    @IBAction func solveButton(_ sender: UIButton) {
        if operationLabel.text != "" {
            
//            operandStack.append(displayValue)
        
            if operandStack.count >= 2 {
                operandStack.removeFirst()
            } else {
                var operands = operationLabel.text!
                
                if operands.contains(" ÷ ") {
                    operands = removeCharactersInString(string: operands, Characters: " ÷ ", replacementString: " ")
                } else if operands.contains(" × ") {
                    operands = removeCharactersInString(string: operands, Characters: " × ", replacementString: " ")
                } else if operands.contains(" − ") {
                    operands = removeCharactersInString(string: operands, Characters: " − ", replacementString: " ")
                } else if operands.contains(" + ") {
                    operands = removeCharactersInString(string: operands, Characters: " + ", replacementString: " ")
                }
                
                operandStack.append(operands)
                operandStack = operandStack.shiftRight()
                print("Operand Stack: \(operandStack)")
                
            }
        }
    }

    func operatorTapped(sender: UIButton) {
        operandStack.append(operationLabel.text!)
        operandStack.append(sender.currentTitle!)
    }
    
    func performOperation(operandStack: [String]) {
        
    }
    
    func removeCharactersInString(string: String, Characters: String, replacementString: String) -> String {
        return string.replacingOccurrences(of: Characters, with: replacementString)
    }
    
    func clearButtonTap(recognizer: UITapGestureRecognizer) {
        guard let button = recognizer.view as? UIButton else { return }
        if operationLabel.text != "" {
            let string = operationLabel.text
            let truncatedString = string?.substring(to: (string?.index(before: (string?.characters.endIndex)!))!)
            
            operationLabel.text = truncatedString
        }
    }
    
    func clearButtonLongPress(recognizer: UILongPressGestureRecognizer) {
        guard let button = recognizer.view as? UIButton else { return }
        
        if operationLabel.text != "" {
            operationLabel.text = ""
        }
        operandStack.removeAll()
    }


}

