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
	@IBOutlet weak var opLabel: UILabel!
	@IBOutlet weak var operationHistoryTableView: UITableView!
	
	private var operandStack: [String]!
	private var prevOp: String!
	private var operationHistory: [MathematicalOperation]!
	private var calculator: Calculator!
	private var managedContext: NSManagedObjectContext!
	let appDelegate = UIApplication.shared.delegate as! AppDelegate

	private let EQUAL_SIGN_STR = "＝"
	private let ERROR_STR = "  ERROR"
	private let DELETE_SYMBOL = "\u{232B}"
	private let CLEAR_TEXT = "  0"
	private let FORMATTER: NumberFormatter = {
		let formatter = NumberFormatter()
		formatter.numberStyle = .decimal
		formatter.maximumFractionDigits = 5
		formatter.groupingSeparator = ","
		formatter.locale = NSLocale.current
		return formatter
	}()
	private let NUMBERS = ["1", "2","3","4","5","6","7","8","9","0","."]
	private let OPS = ["(",")","÷","×","−","+"]
	private let ATTRIBUTE_GREEN = [NSAttributedStringKey.foregroundColor: UIColor.init(hex: 0x22C663) ]
	private let ATTRIBUTE_GREY = [NSAttributedStringKey.foregroundColor: UIColor.init(hex: 0x787878) ]
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		calculator = Calculator()
		operationHistory = [MathematicalOperation]()
		prevOp = String()
		operandStack = [String]()
		
//		let appDelegate = UIApplication.shared.delegate as! AppDelegate
//		self.managedContext = appDelegate.persistentContainer.viewContext
		
		//  Create the refresh action for the table view so that we can clear the table view when the user pulls down on the table view
		let clearHistoryControl = UIRefreshControl()
		clearHistoryControl.addTarget(self, action: #selector(CalculatorViewController.clearHistory(refreshControl:)), for: .valueChanged)
		self.operationHistoryTableView.allowsSelection = true
		
		self.operationHistoryTableView.addSubview(clearHistoryControl)
		
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
			
			//  Add a long press gesture recognizer to the clear button so that we can have both a clear and backspace action for the  button
			if button.currentTitle == self.DELETE_SYMBOL {
				let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(CalculatorViewController.clearOperationLabel(sender:)))
				longPressRecognizer.minimumPressDuration = 0.19
				button.addGestureRecognizer(longPressRecognizer)
			}
		}
		self.buttonCollection.removeAll()
		
	}
	
	@IBAction func solveButton(_ sender: UIButton) {
		
		/*
		 * Populate operandStack by using regular expressions. In this case, split at every space
		 * example: "3 + 3" -> ["3", "+", "3"]
		 */
		operandStack = (opLabel.text?.components(separatedBy: " "))!
		
		operandStack.removeFirst(2)
		
		var i = 0
		for o in operandStack {
			if o == "" {
				operandStack.remove(at: i)
			}
			i += 1
		}
		
		if prevOp == opLabel.text || OPS.contains(operandStack[operandStack.count - 1]){
			DispatchQueue.main.async {
				self.answerLabel.text = self.ERROR_STR
				self.operandStack.removeAll()
				self.delay(1, closure: {
					self.answerLabel.text = "0"
				})
			}
			return
		}
		
//		if (previousOp == operationLabel.text) || ((operandStack.count < 3) && (previousOp != operationLabel.text)) {
//			DispatchQueue.main.async {
//				self.answerLabel.text = self.ERROR_STR
//				self.operandStack.removeAll()
//				self.delay(3, closure: {
//					self.answerLabel.text = "0"
//				})
//			}
//			return
//		}
		
		let calculationResult = calculate()
		calculator.clear()  //  Clear the calculator's accumlator so that we get an accurate result
		
		answerLabel.text = FORMATTER.string(from: NSNumber.init(value: calculationResult))
		
		//  Add the operation to the history array so that the table view can be updated with accurate data
		let operation = MathematicalOperation(result: calculationResult, operandStack: operandStack, managedObjectContext: appDelegate.persistentContainer.viewContext)
//		let operation = MathematicalOperation(result: calculationResult, operandStack: operandStack)
		operationHistory.append(operation)
		operationHistoryTableView.reloadData()
		
		
		//  Scroll to the bottom of the table view so that the user can see all their most recent operation
		if operationHistory.count > 3 {
			let indexPath = NSIndexPath(row: operationHistory.count - 1, section: 0)
			operationHistoryTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
		}
		
		DispatchQueue.global(qos: .background).async {
			self.save(operation: operation)
		}

		operandStack.removeAll()
		prevOp = opLabel.text!
	}
	
	/*
	* @return the result of the operation that the user inputed
	* This method does the actual calculation,
	*/
	private func calculate() -> Double {
		var stack = self.operandStack!
		
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
	* Determines what table view cell was pressed and fetches the
	* result of the operation from that cell and places the result in the operation
	* label
	*/
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		clearTextField()
		let operation = self.operationHistory[indexPath.row]
		
		DispatchQueue.main.async {
			if self.opLabel.text == self.CLEAR_TEXT {
				self.updateOpLabel(text: String(operation.getResult()))
			} else {
				self.updateOpLabel(text: self.opLabel.text! + String(operation.getResult()))
			}
		}

		
//		if opLabel.text == CLEAR_TEXT {
//			updateOpLabel(text: FORMATTER.string(from: NSNumber.init(value: operation.getResult()))!)
//		} else {
//			updateOpLabel(text: opLabel.text! + FORMATTER.string(from: NSNumber.init(value: operation.getResult()))!)
//		}
	}
	
	/*
	* Used for the initial creation of the table view cells and for refreshing the
	* table view when tableView.reloadTableData() is called. In this method, the operation object
	* that corresponds with the table view cell is loaded and used to initialize the two labels
	* in the cell with the appropriate data(Operation and the result of that operation)
	*/
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let operation = self.operationHistory[indexPath.row]
		let cell = tableView.dequeueReusableCell(withIdentifier: "OperationCell") as? OperationHistoryCell!
		
		cell?.resultLabel.text = FORMATTER.string(from: NSNumber.init(value: operation.getResult()))
		
		var operationStr = ""
		
		for s in operation.getOperandStack() {
			let character: String!
			if OPS.contains(s) {
				character = " " + s + " "
			} else {
				character = s
			}
			operationStr += character
		}
		
		var index: String.Index!
		let attributedString = NSMutableAttributedString()
		
		if opLabel.text == CLEAR_TEXT {
			attributedString.append(NSAttributedString(string: "  "))
		}
		
		//  Can't use 'updateOpLabel(text: String)' because we are updating the table view cell's label
		for i in 0..<operationStr.count {
			index = operationStr.index(operationStr.startIndex, offsetBy: i)
			if OPS.contains(String(operationStr[index])) {
				let attributedStringChar = NSAttributedString(string: String(operationStr[index]), attributes: self.ATTRIBUTE_GREEN)
				attributedString.append(attributedStringChar)
			} else {
				let attributedStringChar = NSAttributedString(string: String(operationStr[index]), attributes: self.ATTRIBUTE_GREY)
				attributedString.append(attributedStringChar)
			}
		}
		
		cell?.operationLabel.attributedText = attributedString
		
		cell!.selectionStyle = .none
		
		return cell!
	}
	
	/*
	* @param text, the string that is replacing the current label text
	* Updates the operationLabel attributed text. This is done by
	* iterating throught 'text'
	* and determining the type of character it is and applying
	* the appropriate attribute to it
	*/
	func updateOpLabel(text: String) {
		var index: String.Index!
		let attributedString = NSMutableAttributedString()
		
		if opLabel.text == CLEAR_TEXT {
			attributedString.append(NSAttributedString(string: "  "))
		}
		
		for i in 0..<text.count {
			index = text.index(text.startIndex, offsetBy: i)
			if OPS.contains(String(text[index])) {
				let attributedStringChar = NSAttributedString(string: String(text[index]), attributes: self.ATTRIBUTE_GREEN)
				attributedString.append(attributedStringChar)
			} else {
				let attributedStringChar = NSAttributedString(string: String(text[index]), attributes: self.ATTRIBUTE_GREY)
				attributedString.append(attributedStringChar)
			}
		}
		DispatchQueue.main.async {
			self.opLabel.attributedText = attributedString
		}
	}
	
	/*
	* Resets all the labels in the view
	* to their default state
	*/
	func clearTextField() {
		if opLabel.text != CLEAR_TEXT || answerLabel.text == ERROR_STR {
			opLabel.text = CLEAR_TEXT
			answerLabel.text = "0"
			calculator.clear()
			operandStack.removeAll()
			prevOp = ""
		}
	}
	
	//  MARK: UI actions
	
	/*
	* Removes all previous operations
	* from the tableView in the view by pulling down on
	* the tableView until a UIActivityIndicatorView appears
	*/
	@objc func clearHistory(refreshControl: UIRefreshControl) {
		DispatchQueue.main.async {
			//  Remove all past operations from the array so that we can clear the table view
			self.operationHistory.removeAll()
			self.operationHistoryTableView.reloadData()
			refreshControl.endRefreshing()
		}
	}
	
	//  The method used to animate the tap of a UIButton
	@objc func buttontapped(sender: UIButton) {
		DispatchQueue.main.async {
			UIView.animate(withDuration: 0.09, delay: 0, options: .curveLinear, animations: {
				sender.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
			})
		}
	}
	
	//  Animate the release of a UIButton
	@objc func buttonReleased(sender: UIButton) {
		DispatchQueue.main.async {
			UIView.animate(withDuration: 0.09, delay: 0, options: .curveLinear, animations: {
				sender.transform = CGAffineTransform(scaleX: 1, y: 1)
			})
		}
	}
	
	//  Detect a tap in any of the view's UIButtons and execute the appropriate action for the button
	@objc func buttonAction(sender: UIButton) {
		var character = (sender.currentTitle)!  //  Read the button's title so that the appropriate action can be executed
		
		if (character == DELETE_SYMBOL || character == EQUAL_SIGN_STR) || (opLabel.text == CLEAR_TEXT && OPS.contains(character)) { return }
		
		var mustBeNumber = false
		if opLabel.text?[(opLabel.text?.index(before: (opLabel.text?.endIndex)!))!] == " " || opLabel.text?[(opLabel.text?.index(before: (opLabel.text?.endIndex)!))!] == "."  {
			mustBeNumber = true
			if ((mustBeNumber) && !NUMBERS.contains(character)) { return }
		}
		
		if opLabel.text == CLEAR_TEXT || self.answerLabel.text == ERROR_STR {
			DispatchQueue.main.async {
				self.opLabel.text = "  "
			}
		}
		
		if OPS.contains(character) /*&& character != "±"*/ {
			character = " " + character + " "
		}
		
		if character == "( / )" /*&& operationLabel.text != CLEAR_TEXT*/ {
			if (opLabel.text?.contains("("))! {
				character = ")"
			} else {
				character = "("
			}
			
		}
		
		if character == "±" && opLabel.text != CLEAR_TEXT {
			if opLabel.text?.dropFirst(2).first == "-" {
				self.updateOpLabel(text: "  " + String(describing: opLabel.text!.dropFirst(3)))
			} else {
				if opLabel.text!.count <= 4  {
					self.updateOpLabel(text: "  -\(String(opLabel.text!.dropFirst(2)))")
				} else {
					let split = opLabel.text?.split(separator: " ")
					print(split![(split?.count)! - 1])
					print(contains(seq: split![(split?.count)! - 1], char: "-"))
					
					if !contains(seq: split![(split?.count)! - 1], char: "-") {
						self.updateOpLabel(text: "\(String(opLabel.text!.dropLast()))-\(String(describing: opLabel.text!.last!))")
					} else {
						let last = "\(String(describing: opLabel.text!.last!))"
						self.updateOpLabel(text: "\(String(opLabel.text!.dropLast(2)))")
					}
				}
			}
			return
		} else if character == "±" && opLabel.text == CLEAR_TEXT {
			DispatchQueue.main.async {
				self.opLabel.text = "  -"
			}
			return
		}
		
		DispatchQueue.main.async {
			var opLabelString = String()
			if (self.opLabel.text! == self.CLEAR_TEXT) {
				opLabelString = "  " + self.opLabel.text! + character
			} else {
				opLabelString = self.opLabel.text! + character
			}
			
			self.updateOpLabel(text: opLabelString)
		}
	}
	
	//  Removes the last character from the string when a tap is detected in the clear button and update operationLabel
	@IBAction func clearButtonTap(_ sender: Any) {
		guard opLabel.text != CLEAR_TEXT && opLabel.text != ERROR_STR else { return }
//		guard opLabel.text?.characters.count > 4 else { updateOpLabel(text: CLEAR_TEXT) }

		if opLabel.text?.count == 4 {
			updateOpLabel(text: CLEAR_TEXT)
			return
		}
	
		if opLabel.text?.last == " " {
			updateOpLabel(text: String(opLabel.text!.dropLast(2)))
//			if operationLabel.text?.trimmingCharacters(in: .whitespaces) == "" {
//				updateOpLabel(text: CLEAR_TEXT)
//			}
		} else {
//			updateOpLabel(text: (operationLabel.text?.substring(to: (operationLabel.text?.index(before: (operationLabel.text?.endIndex)!))!))!)
			opLabel.text?.removeLast(1)
			updateOpLabel(text: opLabel.text!)
		}
		if opLabel.text?.trimmingCharacters(in: .whitespaces) == "" {
			updateOpLabel(text: CLEAR_TEXT)
		}
	}
	
	/*
	* Clears the text field when a long press is detected
	* on the clear button
	*/
	@objc func clearOperationLabel(sender: UIButton) {
		guard opLabel.text != CLEAR_TEXT else {
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
	
	private func contains(seq: String.SubSequence, char: Character) -> Bool {
		for s in seq {
			if s == char {
				return true
			}
		}
		return false
 	}
	
	//  MARK: Core Data methods
	func save(operation: MathematicalOperation) {		
		let entity = NSEntityDescription.entity(forEntityName: "Operation", in: managedContext)
		let object = NSManagedObject(entity: entity!, insertInto: managedContext)
		
		object.setValue(operation.getResult(), forKey: "operandstack")
		object.setValue(operation.getOperandStack(), forKey: "result")
		
		do {
			try managedContext.save()
		} catch { NSLog("Could not save core data stack") }
	}
	
	func read() {
		let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Operation")

		var fetchedObjects: [NSManagedObject]!
		do {
			try fetchedObjects = managedContext.fetch(fetchRequest) as! [NSManagedObject]
		} catch { NSLog("Could not fetch data from core data stack") }

		if let data = fetchedObjects {
			for object in data {
				operationHistory.append(MathematicalOperation(result: object.value(forKey: "result") as! Float64, operandStack: object.value(forKey: "operandstack") as! [String], managedObjectContext: managedContext))
				operationHistoryTableView.reloadData()
			}
		} else {
			print("Error reading data from core data stack")
		}
	}
}

