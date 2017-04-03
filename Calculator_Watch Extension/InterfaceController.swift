//
//  InterfaceController.swift
//  Calculator_Watch Extension
//
//  Created by Brandon Phan on 12/14/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import WatchKit
import Foundation

class InterfaceController: WKInterfaceController {

    @IBOutlet var answerLabel: WKInterfaceLabel!
    @IBOutlet var operationLabel: WKInterfaceLabel!
    
    var buttons: [String : WKInterfaceButton]!
    
    var opLabelText = "  0"
    
    private let attributeGreen = [NSForegroundColorAttributeName: UIColor.init(hex: 0x22C663) ]
    private let attributeGrey = [NSForegroundColorAttributeName: UIColor.init(hex: 0x787878) ]
    
    private let numbers = ["1", "2","3","4","5","6","7","8","9","0","."]
    private let ops = ["(",")","÷","×","−","+"]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

    @IBAction func sevenButton() {
        if opLabelText == "  0" {
            opLabelText = "  7"
        } else {
            opLabelText += "7"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func eightButton() {
        if opLabelText == "  0" {
            opLabelText = "  8"
        } else {
            opLabelText += "8"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func nineButton() {
        if opLabelText == "  0" {
            opLabelText = "  9"
        } else {
            opLabelText += "9"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func fourButton() {
        if opLabelText == "  0" {
            opLabelText = "  4"
        } else {
            opLabelText += "4"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func fiveButton() {
        if opLabelText == "  0" {
            opLabelText = "  5"
        } else {
            opLabelText += "5"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func sixButton() {
        if opLabelText == "  0" {
            opLabelText = "  6"
        } else {
            opLabelText += "6"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func oneButton() {
        if opLabelText == "  0" {
            opLabelText = "  1"
        } else {
            opLabelText += "1"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func twoButton() {
        if opLabelText == "  0" {
            opLabelText = "  2"
        } else {
            opLabelText += "2"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func threeButton() {
        if opLabelText == "  0" {
            opLabelText = "  3"
        } else {
            opLabelText += "3"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func zeroButton() {
        if opLabelText == "  0" {
            opLabelText = "  0"
        } else {
            opLabelText += "0"
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func decimalButton() {
        if opLabelText == "  0" {
            opLabelText = "  ."
        } else {
            opLabelText += "."
        }
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func clearButton() {
        opLabelText = " 0"
        answerLabel.setText("")
        updateOpLabel(text: opLabelText)
    }
    
    @IBAction func addButton() {
        guard opLabelText != "  0" else { return }
        opLabelText += " + "
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func divideButton() {
        guard opLabelText != "  0" else { return }
        opLabelText += " ÷ "
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func multiplyButton() {
        guard opLabelText != "  0" else { return }
        opLabelText += " × "
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    @IBAction func subtractButton() {
        guard opLabelText != "  0" else { return }
        opLabelText += " − "
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    
    private let calculator = Calculator()
    
    private let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 5
        formatter.groupingSeparator = ","
        formatter.locale = NSLocale.current
        return formatter
    }()
    
    func evaluate() {
        let calculationResult = calculate()
        calculator.clear()  //  Clear the calculator's accumlator so that we get an accurate result
        answerLabel.setText(String(calculationResult))
    }
    
    private func calculate() -> Double {
        var stack = opLabelText.components(separatedBy: " ")
        var result = 0.0
    
        for _ in 0...1 {
            stack.remove(at: 0)
        }
        
        if (stack.contains("")) {
            var i = 0
            for s in stack {
                if s == "" {
                    stack.remove(at: i)
                } else {
                    i += 1
                    continue
                }
                i += 1
            }   
        }
        
        guard stack.count >= 3 else { return Double(stack[0])! }
        
        while stack.count >= 3 {
            
            calculator.setOperand(operand: Double(stack[0])!)
            calculator.performOperation(symbol: String(stack[1]))
            calculator.setOperand(operand: Double(stack[2])!)
            calculator.performOperation(symbol: String(stack[1]))
            
            result = calculator.result
            
            for _ in 0..<3 {
                stack.remove(at: 0)
            }
            
            switch stack.count {
            case 0:
                return result
            default:
                calculator.clear()
                stack.append(String(format: "%.0f", result))
                stack = stack.shiftedRight()
            }
        }
        
        calculator.clear()
        stack.removeAll()
        return result
    }
    
    func updateOpLabel(text: String) {
        DispatchQueue.global().async {
            var index: String.Index!
            let attributedString = NSMutableAttributedString()
            
            if self.opLabelText == "  0" {
                attributedString.append(NSAttributedString(string: "  "))
            }
            
            for i in 0..<text.characters.count {
                index = text.index(text.startIndex, offsetBy: i)
                if self.ops.contains(String(text[index])) {
                    let attributedStringChar = NSAttributedString(string: String(text[index]), attributes: self.attributeGreen)
                    attributedString.append(attributedStringChar)
                } else {
                    let attributedStringChar = NSAttributedString(string: String(text[index]), attributes: self.attributeGrey)
                    attributedString.append(attributedStringChar)
                }
            }
            DispatchQueue.main.async {
                self.operationLabel.setAttributedText(attributedString)
            }
        }
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
