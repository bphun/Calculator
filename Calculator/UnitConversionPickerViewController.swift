//
//  UnitConversionViewController.swift
//  Calculator
//
//  Created by Brandon Phan on 12/4/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

class UnitConversionPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    let unitConverter = UnitConverter()
    var categories: [Category]!
    
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let swipeGestureRecognizer: UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(UnitConversionPickerViewController.showCalculatorView))
//        swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirection.left
//        self.view.addGestureRecognizer(swipeGestureRecognizer)
        
        categories = unitConverter.getCategories()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversionCell") as? UnitconversionCell!
        
        cell?.nameLabel.text = category.getName()
        cell?.imageView?.image = category.getImage()
        
        cell?.selectionStyle = .default
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Sdf")
        self.performSegue(withIdentifier: "tableViewSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "tableViewSegue":
            let viewController = segue.destination as! UnitConversionViewController
            viewController.setCategory(category: category)
        default:
            return
        }
    }
    
    
    
}
