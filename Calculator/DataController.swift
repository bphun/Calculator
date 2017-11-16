//
//  DataController.swift
//  Calculator
//
//  Created by Brandon Phan on 11/11/17.
//  Copyright © 2017 Brandon Phan. All rights reserved.
//

import CoreData
import UIKit

class DataController: NSObject {
	init(completionClosure: @escaping () -> ()) {
		super.init()
		let persistentContainer = NSPersistentContainer(name: "CoreDataModel")
		persistentContainer.loadPersistentStores() { (description, error) in
			if let error = error {
				fatalError("Failed to load Core Data stack: \(error)")
			}
			completionClosure()
		}
	}
}
