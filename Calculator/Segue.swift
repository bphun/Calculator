//
//  Segue.swift
//  Calculator
//
//  Created by Brandon Phan on 12/11/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

class segue: UIStoryboardSegue {
    
    override func perform() {
        let screenWidth = UIScreen.main.bounds.size.width
        let screenHeight = UIScreen.main.bounds.size.height
        
        let firstVC = self.source.view as UIView!
        let secondVC = self.destination.view as UIView!
        
        secondVC?.frame = CGRect(x: screenWidth, y: 0.0, width: screenWidth, height: screenHeight)
        
        let window = UIApplication.shared.keyWindow
        window?.insertSubview(secondVC!, aboveSubview: firstVC!)
        
        UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveLinear, animations: { () -> Void in
            firstVC?.frame = (firstVC?.frame)!.offsetBy(dx: screenWidth, dy: 0.0)
            secondVC?.frame = (secondVC?.frame)!.offsetBy(dx: screenWidth, dy: 0.0)
            
        }, completion: { (finished) -> Void in
            self.source.present(self.destination as UIViewController, animated: false, completion: nil)
        })
    }
        
}
