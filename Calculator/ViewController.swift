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
        
        for button in buttonCollection {
            button.layer.borderWidth = 0.4
            button.layer.borderColor = UIColor.black().cgColor
            button.addTarget(self, action: #selector(ViewController.appendCharacter(sender:)), for: .touchUpInside)
        }
    }

    
    func appendCharacter(sender: UIButton) {
        
        var character = (sender.currentTitle)!
        var attributedString = NSMutableAttributedString(string: character, attributes: [NSFontAttributeName: UIFont(name: "Avenir Next", size: 18.0)!])
        
        switch character {
            
        case "(":
            character = " ( "
            operationLabel.textColor = UIColor(red: 34, green: 200, blue: 99, alpha: 1)
            
        case ")":
            character = " ) "
            operationLabel.textColor = UIColor(red: 34, green: 200, blue: 99, alpha: 1)

        case "÷":
            character = " ÷ "
            operationLabel.textColor = UIColor(red: 34, green: 200, blue: 99, alpha: 1)
            
        case "×":
            character = " × "
            operationLabel.textColor = UIColor(red: 34, green: 200, blue: 99, alpha: 1)
            
        case "−":
            character = " − "
            operationLabel.textColor = UIColor(red: 34, green: 200, blue: 99, alpha: 1)
            
        case "+":
            character = " + "
            operationLabel.textColor = UIColor(red: 34, green: 200, blue: 99, alpha: 1)
            
        default:
            character = (sender.currentTitle)!
            operationLabel.textColor = UIColor.white()
        }

        operationLabel.attributedText = operationLabel.text! + attributedString
    }
    
    

}

