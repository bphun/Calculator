//
//  UnitConversionViewController.swift
//  Calculator
//
//  Created by Brandon Phan on 12/4/16.
//  Copyright © 2016 Brandon Phan. All rights reserved.
//

import Foundation
import UIKit

class UnitConversionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    @IBOutlet weak var tableView: UITableView!
    let unitConverter = UnitConverter()
    var categories: [Category]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        categories = unitConverter.getCategories()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: "tableViewSegue", sender: <#T##Any?#>)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let category = categories[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ConversionCell") as? UnitconversionCell!
        
        cell?.nameLabel.text = category.getName()
        cell?.imageView?.image = category.getImage()
        
        return cell!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier! {
        case "tableViewSegue":
            var viewController = segue.destination as 

        default:
            <#code#>
        }
    }
    
    
    
}
