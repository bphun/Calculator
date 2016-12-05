//
//  ViewController.swift
//  Calculator
//
//  Created by Brandon Phan on 7/23/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var operationHistoryTableView: UITableView!
    
    lazy var operationHistory = [MathematicalOperation]()
    
    private let calculator = Calculator()

    private lazy var numbers = ["1", "2","3","4","5","6","7","8","9","0","."]
    private lazy var ops = ["(",")","÷","×","−","+"]
   
    let attributeGreen = [NSForegroundColorAttributeName: UIColor.init(hex: 0x22C663) ]
    let attributeGrey = [NSForegroundColorAttributeName: UIColor.init(hex: 0x787878) ]
    
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 6
        formatter.notANumberSymbol = "  ERROR"
        formatter.groupingSeparator = " "
        formatter.locale = NSLocale.current
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            if (!UIAccessibilityIsReduceTransparencyEnabled()) {
                self.operationHistoryTableView.backgroundColor = UIColor.clear
                let blurEffect = UIBlurEffect(style: .dark)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                self.operationHistoryTableView.backgroundView = blurEffectView
                
                //if you want translucent vibrant table view separator lines
                self.operationHistoryTableView.separatorEffect = UIVibrancyEffect(blurEffect: blurEffect)
            }
            let clearHistoryControl = UIRefreshControl()
            clearHistoryControl.addTarget(self, action: #selector(ViewController.clearHistory(refreshControl:)), for: .valueChanged)
            self.operationHistoryTableView.addSubview(clearHistoryControl)
            self.operationHistoryTableView.allowsSelection = true
        }
        
        DispatchQueue.global().async {
            self.operationHistoryTableView.delegate = self
            self.operationHistoryTableView.dataSource = self
            
            for button in self.buttonCollection {
                DispatchQueue.main.async {
                    UIApplication.shared.statusBarStyle = .lightContent
                    button.layer.borderWidth = 0.28
                    button.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
                    button.addTarget(self, action: #selector(ViewController.buttontapped(sender:)), for: .touchDown)
                    button.addTarget(self, action: #selector(ViewController.buttontapped(sender:)), for: .touchDragInside)
                    button.addTarget(self, action: #selector(ViewController.buttonAction(sender:)), for: .touchDown)
                    button.addTarget(self, action: #selector(ViewController.buttonReleased(sender:)), for: .touchUpInside)
                    button.addTarget(self, action: #selector(ViewController.buttonReleased(sender:)), for: .touchDragExit)
                }
            }
            self.buttonCollection.removeAll()
        }
    }
    
    func buttontapped(sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.09, delay: 0, options: .curveLinear, animations: {
                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            })
            if sender.currentTitle == "C" {
                self.clearTextField()
                self.calculator.clear()
            }
        }
    }
    
    func buttonReleased(sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.09, delay: 0, options: .curveLinear, animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    func buttonAction(sender: UIButton) {
        DispatchQueue.global().async {
            
            var character = (sender.currentTitle)!

            if (character == "C" || character == "＝") || (self.operationLabel.text == "  0" && self.ops.contains(character)) { return }
            
            var mustBeNumber = false
            if self.operationLabel.text?[(self.operationLabel.text?.index(before: (self.operationLabel.text?.endIndex)!))!] == " " || self.operationLabel.text?[(self.operationLabel.text?.index(before: (self.operationLabel.text?.endIndex)!))!] == "."  {
                mustBeNumber = true
            }
            
            if ((mustBeNumber) && !self.numbers.contains(character)) { return }
            
            if self.operationLabel.text == "  0" {
                DispatchQueue.main.async {
                    self.operationLabel.text = "  "
                }
            }
            
            if self.ops.contains(character) && character != "+ / -" {
                character = " " + character + " "
            } else if character == "+ / -" {
                character = "-"
            }
            
            DispatchQueue.main.async {
                var opLabelString = String()
                if (self.operationLabel.text! == "  0") {
                    opLabelString = "  " + self.operationLabel.text! + character
                } else {
                    opLabelString = self.operationLabel.text! + character
                }
                self.updateOpLabel(text: opLabelString)
            }
        }
    }
    
    var operandStack = [String]()
    var previousOp = String()
    
    @IBAction func solveButton(_ sender: UIButton) {
        
        operandStack = (operationLabel.text?.components(separatedBy: " "))!
        
        for _ in 0...1 {
            operandStack.remove(at: 0)
        }

        if (previousOp == operationLabel.text) || ((operandStack.count < 3) && (previousOp != operationLabel.text)) {
            DispatchQueue.main.async {
                self.operationLabel.text = "  ERROR"
                self.operandStack.removeAll()
                
                self.delay(3, closure: {
                    self.operationLabel.text = "  0"
                })
            }
            return
        }
        
//        if ((previousOp == operationLabel.text) || (operandStack.count) <= 3 && (previousOp != operationLabel.text)) {
//            DispatchQueue.main.async {
//                self.operationLabel.text = "  ERROR"
//                self.operandStack.removeAll()
//                
//                self.delay(3, closure: {
//                    self.operationLabel.text = "  0"
//                })
//            }
//            return
//        }
        
        let calculationResult = calculate()
        calculator.clear()
        
        let formattedResult = formatter.string(from: NSNumber.init(value: calculationResult))
        answerLabel.text = formattedResult
        
        let operation = MathematicalOperation(result: calculationResult, operandStack: operandStack)
        
        //            let managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        //            let operation = MathematicalOperation(result: calculationResult, operation: operandStack, context: managedContext)
        
        
        operationHistory.append(operation)
        
        //            saveEntity(key: "result", value: calculationResult)
        //            saveEntity(key: "operation", value: operandStack)
        
        operationHistoryTableView.reloadData()
        
        if operationHistory.count > 3 {
            let indexPath = NSIndexPath(row: operationHistory.count - 1, section: 0)
            operationHistoryTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
        
        operandStack.removeAll()
        previousOp = operationLabel.text!
    }
    
    private func calculate() -> Double {
        var stack = self.operandStack
        var result = 0.0
        
        guard stack[2] != "" else { return Double(stack[0])! }
        
        while stack.count >= 3 {
            
            calculator.setOperand(operand: Double(stack[0])!)
            calculator.performOperation(symbol: String(stack[1]))
            calculator.setOperand(operand: Double(stack[2])!)
            calculator.performOperation(symbol: String(stack[1]))
           
            result = calculator.result
            
            for _ in 0..<3 {
                stack.remove(at: 0)
            }
            
            if stack.count == 0 {
                return result
            } else if stack.count >= 2 {
                calculator.clear()
                stack.append(String(format: "%.0f", result))
                stack = stack.shiftedRight()
            }
        }
        
        calculator.clear()
        stack.removeAll()
        return result
    }
    
    private func delay(_ delay:Double, closure:@escaping ()->()) {
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: closure)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operationHistory.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let operation = self.operationHistory[indexPath.row]
        if operationLabel.text == "  0" {
            updateOpLabel(text: "  " + String(operation.getResult()))
        } else {
            updateOpLabel(text: operationLabel.text! + String(operation.getResult()))
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let operation = self.operationHistory[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell") as? OperationHistoryCell!
        
        cell?.resultLabel.text = formatter.string(from: NSNumber.init(value: operation.getResult()))
        
        var operationStr = ""
        
        for s in operation.getOperandStack() {
            let character: String!
            if ops.contains(s) {
                character = " " + s + " "
            } else {
                character = s
            }
            operationStr += character
        }
        
        var index: String.Index!
        let attributedString = NSMutableAttributedString()
        
        if operationLabel.text == "  0" {
            attributedString.append(NSAttributedString(string: "  "))
        }
        
        for i in 0..<operationStr.characters.count {
            index = operationStr.index(operationStr.startIndex, offsetBy: i)
            if self.ops.contains(String(operationStr[index])) {
                let attributedStringChar = NSAttributedString(string: String(operationStr[index]), attributes: self.attributeGreen)
                attributedString.append(attributedStringChar)
            } else {
                let attributedStringChar = NSAttributedString(string: String(operationStr[index]), attributes: self.attributeGrey)
                attributedString.append(attributedStringChar)
            }
        }
        
        cell?.operationLabel.attributedText = attributedString
        
        
        cell!.selectionStyle = .none
        
        return cell!
    }
    
    func updateOpLabel(text: String) {
        var index: String.Index!
        let attributedString = NSMutableAttributedString()
        
        if operationLabel.text == "  0" {
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
        
        self.operationLabel.attributedText = attributedString
    }
    
    
    func clearTextField() {
        if operationLabel.text != "  0" || operationLabel.text == "  ERROR" {
            operationLabel.text = "  0"
            answerLabel.text = "0"
            calculator.clear()
            operandStack.removeAll()
            previousOp = ""
        }
    }
    
    func clearHistory(refreshControl: UIRefreshControl) {
        DispatchQueue.main.async {
            self.operationHistory.removeAll()
            self.operationHistoryTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    func saveAttribute(attribute: String, key: String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let managedContext = appDelegate.managedObjectContext
        
        let entity =  NSEntityDescription.entity(forEntityName: "OperationHistory", in: managedContext)
        
        let object = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        object.setValue(attribute, forKey: key)
        
        do {
            try managedContext.save()
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
}

