//
//  ViewController.swift
//  Calculator
//
//  Created by Brandon Phan on 7/23/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import UIKit
import CoreData

class CalculatorViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var operationHistoryTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  Create the refresh action for the table view so that we can clear the table view when the user pulls down on the table view
        let clearHistoryControl = UIRefreshControl()
        clearHistoryControl.addTarget(self, action: #selector(CalculatorViewController.clearHistory(refreshControl:)), for: .valueChanged)
        self.operationHistoryTableView.allowsSelection = true

        DispatchQueue.main.async {
            self.operationHistoryTableView.addSubview(clearHistoryControl)
        }
        
        DispatchQueue.global().async {
            self.operationHistoryTableView.delegate = self
            self.operationHistoryTableView.dataSource = self
            
            //  Initialize all the buttons with the necessary actions when a certian action is executed
            for button in self.buttonCollection {
                UIApplication.shared.statusBarStyle = .lightContent
                button.layer.borderWidth = 0.28
                button.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
                button.addTarget(self, action: #selector(CalculatorViewController.buttontapped(sender:)), for: .touchDown)
                button.addTarget(self, action: #selector(CalculatorViewController.buttontapped(sender:)), for: .touchDragInside)
                button.addTarget(self, action: #selector(CalculatorViewController.buttonAction(sender:)), for: .touchDown)
                button.addTarget(self, action: #selector(CalculatorViewController.buttonReleased(sender:)), for: .touchUpInside)
                button.addTarget(self, action: #selector(CalculatorViewController.buttonReleased(sender:)), for: .touchDragExit)
                
                //  Add a long press gesture recognizer to the clear button so that we can have both a clear and backspace action for the clear button
                if button.currentTitle == "\u{232B}" {
                    let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CalculatorViewController.clearOperationLabel(sender:)))
                    longPressRecognizer.minimumPressDuration = 0.19
                    button.addGestureRecognizer(longPressRecognizer)
                }
            }
            self.buttonCollection.removeAll()
        }
    }
    
    private var operandStack = [String]()
    private var previousOp = String()
    
    private lazy var operationHistory = [MathematicalOperation]()
    
    private let calculator = Calculator()
    
    private static let numbers = ["1", "2","3","4","5","6","7","8","9","0","."]
    private static let ops = ["(",")","÷","×","−","+"]
    
    private static let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 5
        formatter.groupingSeparator = ","
        formatter.locale = NSLocale.current
        return formatter
    }()
    
    private let attributeGreen = [NSForegroundColorAttributeName: UIColor.init(hex: 0x22C663) ]
    private let attributeGrey = [NSForegroundColorAttributeName: UIColor.init(hex: 0x787878) ]
    
    @IBAction func solveButton(_ sender: UIButton) {
        
        /* Populate operandStack by using regular expressions, in this case it is just one empty space
         * example: "3 + 3" -> ["3", "+", "3"]
        */
        operandStack = (operationLabel.text?.components(separatedBy: " "))!

        // Remove the first two spaces before the initial number, the spaces are there for cosmetic reasons
        for _ in 0...1 {
            operandStack.remove(at: 0)
        }
        
        /* Determine if the previous operation is the same as the one in the text field, if so return
         * then determine if there is an adequate number operands in the label, if not return
         */
        if (previousOp == operationLabel.text) || ((operandStack.count < 3) && (previousOp != operationLabel.text)) {
            DispatchQueue.main.async {
                self.answerLabel.text = "  ERROR"
                self.operandStack.removeAll()
                self.delay(3, closure: {
                    self.answerLabel.text = "0"
                })
            }
            return
        }
        
        let calculationResult = calculate()
        calculator.clear()  //  Clear the calculator's accumlator so that we get an accurate result
        
        //  Format the result with the pre-determine settings so that the number is "pretty"
        let formattedResult = CalculatorViewController.formatter.string(from: NSNumber.init(value: calculationResult))
        
        answerLabel.text = formattedResult
        
        //  Create an operation object, which is used ot store the recently performed operation and the resulting answer to that operation
        let operation = MathematicalOperation(result: calculationResult, operandStack: operandStack)
//        let operation = MathematicalOperation(result: calculationResult, operandStack: operandStack, context:  )

        
        //  Add the operation to the history array so that the table view can be updated with accurate data
        operationHistory.append(operation)
        operationHistoryTableView.reloadData()
        
        //  Scroll to the bottom of the table view so taht the user can see all their most recent operation
        if operationHistory.count > 3 {
            let indexPath = NSIndexPath(row: operationHistory.count - 1, section: 0)
            operationHistoryTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
        
        operandStack.removeAll()    // Clear the operand stack becuase we don't need it any more and to reduce memory usage
        previousOp = operationLabel.text!   //  Update previous op variable with the operation that was just completed so that we can use it to check with the next operation
    }
    
    /*
     * @return the result of the operation that the user inputed
     * This method does the actual calculation,
    */
    private func calculate() -> Double {
        var stack = self.operandStack
        
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
        
        var result = 0.0
        
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
    
    /*
     * @param delay time that needs to be passed for the method to terminate
     * Creates a delay by usng GCD's dispatch after method
    */
    private func delay(_ delay: Double, closure:@escaping ()->()) {
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: closure)
    }
    
    //  Sets the maximum number of cells in the table view
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operationHistory.count
    }
    
    /*
     * This method determines what table view cell was pressed and fetches the 
     * result of the operation from that cell and places the result in the operation
     * label
    */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let operation = self.operationHistory[indexPath.row]
        if operationLabel.text == "  0" {
            updateOpLabel(text: "  " + String(operation.getResult()))
        } else {
            updateOpLabel(text: operationLabel.text! + String(operation.getResult()))
        }
    }
    
    /*
     * This method is used for the initial creation of the table view cells and for refreshing the
     * table view when tableView.reloadTableData() is called. In this method, the operation object
     * that corresponds with the table view cell is loaded and used to initialize the two labels
     * in the cell with the appropriate data(Operation and the result of that operation)
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let operation = self.operationHistory[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell") as? OperationHistoryCell!
        
        cell?.resultLabel.text = CalculatorViewController.formatter.string(from: NSNumber.init(value: operation.getResult()))
        
        var operationStr = ""
        
        for s in operation.getOperandStack() {
            let character: String!
            if CalculatorViewController.ops.contains(s) {
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
        
        //  Can't use 'updateOpLabel(text: String)' because we are updating the table view cell's label
        for i in 0..<operationStr.characters.count {
            index = operationStr.index(operationStr.startIndex, offsetBy: i)
            if CalculatorViewController.ops.contains(String(operationStr[index])) {
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
    
    /*
     * @param text, the string that is replacing the current label text
     * This method is used to update the operationLabel
     * attributed text. This is done by iterating throught 'text' 
     * and determining the type of character it is and applying
     * the appropriate attribute to it
    */
    func updateOpLabel(text: String) {
        DispatchQueue.global().async {
            var index: String.Index!
            let attributedString = NSMutableAttributedString()
            
            if self.operationLabel.text == "  0" {
                attributedString.append(NSAttributedString(string: "  "))
            }
            
            for i in 0..<text.characters.count {
                index = text.index(text.startIndex, offsetBy: i)
                if CalculatorViewController.ops.contains(String(text[index])) {
                    let attributedStringChar = NSAttributedString(string: String(text[index]), attributes: self.attributeGreen)
                    attributedString.append(attributedStringChar)
                } else {
                    let attributedStringChar = NSAttributedString(string: String(text[index]), attributes: self.attributeGrey)
                    attributedString.append(attributedStringChar)
                }
            }
            DispatchQueue.main.async {
                self.operationLabel.attributedText = attributedString
            }
        }
    }
    
    /*
     * This method is used to reset all the labels in the view
     * to their default state
    */
    func clearTextField() {
        if operationLabel.text != "  0" || answerLabel.text == "  ERROR" {
            operationLabel.text = "  0"
            answerLabel.text = "0"
            calculator.clear()
            operandStack.removeAll()
            previousOp = ""
        }
    }
    
    //  MARK: UI actions
    
    /*
     * This method is used to remove all previous operations
     * from the tableView in the view by pulling down on 
     * the tableView until a UIActivityIndicatorView appears
    */
    func clearHistory(refreshControl: UIRefreshControl) {
        DispatchQueue.main.async {
            //  Remove all past operations from the array so that we can clear the table view
            self.operationHistory.removeAll()
            self.operationHistoryTableView.reloadData()
            refreshControl.endRefreshing()
        }
    }
    
    //  The method used to animate the tap of a UIButton
    func buttontapped(sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.09, delay: 0, options: .curveLinear, animations: {
                sender.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            })
        }
    }
    
    //  The method used to animate the release of a UIButton
    func buttonReleased(sender: UIButton) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.09, delay: 0, options: .curveLinear, animations: {
                sender.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    //  Method used to detect a tap in any of the view's UIButtons and execute the appropriate action for the button
    func buttonAction(sender: UIButton) {
        DispatchQueue.global().async {
            
            var character = (sender.currentTitle)!  //  Read the button's title so that the appropriate action can be executed
            
            if (character == "\u{232B}" || character == "＝") || (self.operationLabel.text == "  0" && CalculatorViewController.ops.contains(character)) { return }
            
            var mustBeNumber = false
            if self.operationLabel.text?[(self.operationLabel.text?.index(before: (self.operationLabel.text?.endIndex)!))!] == " " || self.operationLabel.text?[(self.operationLabel.text?.index(before: (self.operationLabel.text?.endIndex)!))!] == "."  {
                mustBeNumber = true
                if ((mustBeNumber) && !CalculatorViewController.numbers.contains(character)) { return }
            }
            
            if self.operationLabel.text == "  0" || self.answerLabel.text == "  ERROR" {
                DispatchQueue.main.async {
                    self.operationLabel.text = "  "
                }
            }
            
            if CalculatorViewController.ops.contains(character) && character != "±" {
                character = " " + character + " "
            }
            
            if character == "( / )" && self.operationLabel.text != "  0" {
                if (self.operationLabel.text?.contains("("))! {
                    character = ")"
                } else {
                    character = "("
                }
            }
            
            if character == "±" && self.operationLabel.text != "  0" {
                if self.operationLabel.text?.characters.first == "-" {
                    self.updateOpLabel(text: String(self.operationLabel.text!.characters.dropFirst()))
                    
                } else {
                    if self.operationLabel.text!.characters.count <= 4 {
                        self.updateOpLabel(text: "  -\(String(self.operationLabel.text!.characters.dropFirst(2)))")
                    } else {
                        let end = self.operationLabel.text?.characters.last
                        self.updateOpLabel(text: "\(String(self.operationLabel.text!.characters.dropLast()))-\(end!)")
                    }
                }
                return
            } else if character == "±" && self.operationLabel.text == "  0" {
                DispatchQueue.main.async {
                    self.operationLabel.text = "  0"
                }
                return
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
    
    //  Removes the last character from the string when a tap is detected in the clear button and update operationLabel
    @IBAction func clearButtonTap(_ sender: Any) {
        guard self.operationLabel.text != "  0" || self.operationLabel.text != "  ERROR" else { return }
        
        if self.operationLabel.text?.characters.last == " " {
            updateOpLabel(text: String(self.operationLabel.text!.characters.dropLast(2)))
            if self.operationLabel.text == " " || self.operationLabel.text == "  " || self.operationLabel.text == "" {
                updateOpLabel(text: "  0")
            }
        } else {
            updateOpLabel(text: (self.operationLabel.text?.substring(to: (self.operationLabel.text?.index(before: (self.operationLabel.text?.endIndex)!))!))!)
        }
    }
    
    /*
     * Clears the text field after a long press is detected
     * on the clear button
     */
    func clearOperationLabel(sender: UIButton) {
        guard self.operationLabel.text != "  0" else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.09, delay: 0, options: .curveLinear, animations: {
                    self.clearButton.transform = CGAffineTransform(scaleX: 1, y: 1)
                })
            }
            return
        }

        self.clearTextField()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.09, delay: 0, options: .curveLinear, animations: {
                self.clearButton.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    //  MARK: Core Data methods
    
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

