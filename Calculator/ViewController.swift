//
//  ViewController.swift
//  Calculator
//
//  Created by Brandon Phan on 7/23/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var buttonCollection: [UIButton]!
    
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var operationLabel: UILabel!
    @IBOutlet weak var operationHistoryTableView: UITableView!
    
    var operationHistory = [MathematicalOperation]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.async {
            var finishedCreatingClearButton = false
            
            self.operationHistoryTableView.delegate = self
            self.operationHistoryTableView.dataSource = self
            
            for button in self.buttonCollection {
                DispatchQueue.main.async {
                    UIApplication.shared.statusBarStyle = .lightContent
                    button.layer.borderWidth = 0.28
                    button.layer.borderColor = UIColor.black.withAlphaComponent(0.5).cgColor
                    button.addTarget(self, action: #selector(ViewController.appendCharacter(sender:)), for: .touchUpInside)
                    
                    if (!finishedCreatingClearButton) {
                        if button.currentTitle == "C" {
                            let clearButtonLongPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.clearButtonLongPress(recognizer:)))
                            clearButtonLongPressGestureRecognizer.minimumPressDuration = 0.25
                            
                            let clearButtonTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.clearButtonTap(recognizer:)))
                            
                            button.addGestureRecognizer(clearButtonLongPressGestureRecognizer)
                            button.addGestureRecognizer(clearButtonTapGestureRecognizer)
                            finishedCreatingClearButton = true
                        }
                    }
                }
            }
            self.buttonCollection.removeAll()
        }
    }
    
    func appendCharacter(sender: UIButton) {
        DispatchQueue.global().async {
        
            if self.operationLabel.text == "  0" || self.operationLabel.text == "ERROR" {
                self.operationLabel.text = "  "
            }
            var character = (sender.currentTitle)!
    
            switch character {
                
            case "(":
                character = " ( "
                break
            case ")":
                character = " ) "
                break
            case "÷":
                character = " ÷ "
                break
            case "×":
                character = " × "
                break
            case "−":
                character = " − "
                break
            case "+":
                character = " + "
                break
            default:
                break
            }
            
            if character != "C" && character != "＝" {
                DispatchQueue.main.async {
                    self.operationLabel.text! += character
                }
            }
        }
    }
    
    var operandStack = [String]()
    var previousOp = String()
    
    @IBAction func solveButton(_ sender: UIButton) {
        
        var opStack = operationLabel.text?.components(separatedBy: " ")
        
        for _ in 0...1 {
            opStack?.remove(at: 0)
        }
        
        let knownOps = ["÷", "×", "−", "+"]
        var n = 0
        for i in knownOps {
            if opStack?[0] == i || opStack?[(opStack?.count)! - 1] == i {
                opStack?.remove(at: n)
            }
            n += 1
        }
        
        if ((previousOp != operationLabel.text) && (opStack?.count)! >= 3){
            
            for i in opStack! {
                operandStack.append(i)
            }
            
            let calculator = Calculator(operandStack: operandStack)
            let calculationResult = calculator.evaluate()
            answerLabel.text = String(calculationResult)
            
            let operation = MathematicalOperation(result: calculationResult, operandStack: operandStack)
            operationHistory.append(operation)
            
            operationHistoryTableView.reloadData()

            if operationHistory.count > 2 {
                let indexPath = NSIndexPath(row: operationHistory.count - 1, section: 0)
                operationHistoryTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            }

            operandStack.removeAll()
            previousOp = operationLabel.text!
        } else {
            if previousOp != operationLabel.text {
                DispatchQueue.main.async {
                    self.operationLabel.text = "  ERROR"
                    self.operandStack.removeAll()
                    
                    self.delay(3, closure: {
                        self.operationLabel.text = "  0"
                    })
                }
            }
        }
        
    }
    
    func clearButtonTap(recognizer: UITapGestureRecognizer) {
        guard (recognizer.view as? UIButton) != nil else { return }
        if operationLabel.text != "" && operationLabel.text != "  0" {
            operationLabel.text = operationLabel.text?.substring(to: (operationLabel.text!.index(before: (operationLabel.text!.characters.endIndex))))
            if operationLabel.text == "" || operationLabel.text == " " || operationLabel.text == "  " {
                operationLabel.text = "  0"
            }
        }
    }
    
    func clearButtonLongPress(recognizer: UILongPressGestureRecognizer) {
        guard (recognizer.view as? UIButton) != nil else { return }
        operationLabel.text = "  0"
        answerLabel.text = "0"
        operandStack.removeAll()
        previousOp.removeAll()
    }
    
    func delay(_ delay:Double, closure:@escaping ()->()) {
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: closure)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operationHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let operation = self.operationHistory[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell") as? OperationHistoryCell!
        
        cell?.resultLabel.text = String(operation.getResult())
        
        var operationStr = ""
        for s in operation.getOperation() {
            var character: String!
            switch s {
            case "(":
                character = " ( "
                break
            case ")":
                character = " ) "
                break
            case "÷":
                character = " ÷ "
                break
            case "×":
                character = " × "
                break
            case "−":
                character = " − "
                break
            case "+":
                character = " + "
                break
            default:
                character = s
                break
            }
            operationStr += character
        }
        
        cell?.operationLabel.text = operationStr
        
        cell!.selectionStyle = .none
        
        return cell!
    }
    func scrollToBottom(animated:Bool) {
        let indexPath = NSIndexPath(row: operationHistory.count - 1, section: 0)
        operationHistoryTableView.scrollToRow(at: indexPath as IndexPath, at: UITableViewScrollPosition.bottom, animated: animated)
    }
}

