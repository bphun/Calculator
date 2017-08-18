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
    
    private var buttons: [String : WKInterfaceButton]!
	private var opLabelText  = "  0"
	private let calculator = Calculator()
	
    private let ATTRIBUTE_GREEN = [NSAttributedStringKey.foregroundColor: UIColor.init(hex: 0x22C663) ]
    private let ATTRIBUTE_GREY = [NSAttributedStringKey.foregroundColor: UIColor.init(hex: 0x787878) ]
    private let OPS = ["(",")","÷","×","−","+"]
	private let OP_LABEL_CLEAR_TEXT = "  0"
	private let SPACING = "  "
	private let FORMATTER: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 5
		formatter.groupingSeparator = ","
		formatter.locale = NSLocale.current
		return formatter
	}()
	
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
    }

	@IBAction func nineButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "9"
		default:
			opLabelText += "9"
		}
		updateOpLabel(text: opLabelText)
		evaluate()
	}
	
    @IBAction func eightButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "8"
		default:
			opLabelText += "8"
		}
		
        updateOpLabel(text: opLabelText)
        evaluate()
    }
	
	@IBAction func sevenButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "7"
		default:
			opLabelText += "7"
		}

		updateOpLabel(text: opLabelText)
		evaluate()
	}
	
	@IBAction func sixButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "6"
		default:
			opLabelText += "6"
		}
		updateOpLabel(text: opLabelText)
		evaluate()
	}
	
    @IBAction func fiveButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "5"
		default:
			 opLabelText += "5"
		}
        updateOpLabel(text: opLabelText)
        evaluate()
    }

	@IBAction func fourButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "4"
		default:
			opLabelText += "4"
		}
		
		updateOpLabel(text: opLabelText)
		evaluate()
	}
	
	@IBAction func threeButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "3"
		default:
			opLabelText += "3"
		}

		updateOpLabel(text: opLabelText)
		evaluate()
	}
	
	@IBAction func twoButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "2"
		default:
			opLabelText += "2"
		}
	
		updateOpLabel(text: opLabelText)
		evaluate()
	}
	
    @IBAction func oneButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "1"
		default:
			opLabelText += "1"
		}
		
        updateOpLabel(text: opLabelText)
        evaluate()
    }

    @IBAction func zeroButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "0"
		default:
			 opLabelText += "0"
		}
		
        updateOpLabel(text: opLabelText)
        evaluate()
    }
	
    @IBAction func decimalButton() {
		switch opLabelText {
		case OP_LABEL_CLEAR_TEXT:
			opLabelText = SPACING + "."
		default:
			opLabelText += "."
		}

        updateOpLabel(text: opLabelText)
        evaluate()
    }
	
    @IBAction func clearButton() {
        opLabelText = OP_LABEL_CLEAR_TEXT
        answerLabel.setText("")
        updateOpLabel(text: opLabelText)
    }
    
    @IBAction func addButton() {
        guard opLabelText != OP_LABEL_CLEAR_TEXT else { return }
        opLabelText += " + "
        updateOpLabel(text: opLabelText)
        evaluate()
    }
	
    @IBAction func divideButton() {
        guard opLabelText != OP_LABEL_CLEAR_TEXT else { return }
        opLabelText += " ÷ "
        updateOpLabel(text: opLabelText)
        evaluate()
    }
	
    @IBAction func multiplyButton() {
        guard opLabelText != OP_LABEL_CLEAR_TEXT else { return }
        opLabelText += " × "
        updateOpLabel(text: opLabelText)
        evaluate()
    }
	
    @IBAction func subtractButton() {
        guard opLabelText != OP_LABEL_CLEAR_TEXT else { return }
        opLabelText += " − "
        updateOpLabel(text: opLabelText)
        evaluate()
    }
    
    func evaluate() {
        let calculationResult = calculate()
        calculator.clear()  //  Clear the calculator's accumlator so that we get an accurate result
        answerLabel.setText(FORMATTER.string(from: NSNumber.init(value: calculationResult)))
		
    }
    
    private func calculate() -> Double {
        var stack = opLabelText.components(separatedBy: " ")
        var result = 0.0
		
		stack.removeFirst(2)
        
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
            
			stack.removeFirst(3)
            
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
		var index: String.Index!
		let attributedString = NSMutableAttributedString()
		
		if self.opLabelText == OP_LABEL_CLEAR_TEXT {
			attributedString.append(NSAttributedString(string: SPACING))
		}
		
		for i in 0..<text.characters.count {
			index = text.index(text.startIndex, offsetBy: i)
			if self.OPS.contains(String(text[index])) {
				let attributedStringChar = NSAttributedString(string: String(text[index]), attributes: self.ATTRIBUTE_GREEN)
				attributedString.append(attributedStringChar)
			} else {
				let attributedStringChar = NSAttributedString(string: String(text[index]), attributes: self.ATTRIBUTE_GREY)
				attributedString.append(attributedStringChar)
			}
		}
		DispatchQueue.main.async {
			self.operationLabel.setAttributedText(attributedString)
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
