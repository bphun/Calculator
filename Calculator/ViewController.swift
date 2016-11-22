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
    
    var operationHistory = [MathematicalOperation]()
    
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

            if character == "C" { return }
            
            let numbers = ["1", "2","3","4","5","6","7","8","9","0"]
            
            if self.operationLabel.text == "  0" && (character == "(" || character == ")" || character == "÷" || character == "×" || character == "−" || character == "+") {
                return
            }
            
            var mustBeNumber = false
            if self.operationLabel.text?[(self.operationLabel.text?.index(before: (self.operationLabel.text?.endIndex)!))!] == " " || self.operationLabel.text?[(self.operationLabel.text?.index(before: (self.operationLabel.text?.endIndex)!))!] == "."  {
                mustBeNumber = true
            }

            if self.operationLabel.text == "  0" {
                self.operationLabel.text = "  "
            }
            
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
                    if (mustBeNumber) {
                        if (!numbers.contains(character)) {
                            return
                        } else {
                            self.operationLabel.text! += character
                        }
                    } else {
                        self.operationLabel.text! += character
                    }
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
        
        //        let knownOps = ["÷", "×", "−", "+"]
        //        var n = 0
        //        for i in knownOps {
        //            if opStack?[0] == i || opStack?[(opStack?.count)! - 1] == i {
        //                opStack?.remove(at: n)
        //            }
        //            n += 1
        //        }
        
        if ((previousOp != operationLabel.text) && (opStack?.count)! >= 3){
            
            for i in opStack! {
                operandStack.append(i)
            }
            
            let calculator = Calculator(operandStack: operandStack)
            let (calculationResult, calcError) = calculator.evaluate()
            if (calcError != "") {
                operationLabel.text! = calcError
                return
            }
            
            answerLabel.text = String(calculationResult)
            
            //            let managedContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
            //            let operation = MathematicalOperation(result: calculationResult, operation: operandStack, context: managedContext)
            let operation = MathematicalOperation(result: calculationResult, operation: operandStack)
            
            
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
    
    private func delay(_ delay:Double, closure:@escaping ()->()) {
        let deadline = DispatchTime.now() + delay
        DispatchQueue.main.asyncAfter(deadline: deadline, execute: closure)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return operationHistory.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let operation = self.operationHistory[indexPath.row]
        operationLabel.text = "  " + String(operation.getResult())
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
    
    func clearTextField() {
        if operationLabel.text != "  0" || operationLabel.text == "  ERROR" {
            operationLabel.text = "  0"
            answerLabel.text = "0"
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

