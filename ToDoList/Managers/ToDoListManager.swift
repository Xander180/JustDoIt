//
//  ListViewManagerViewModel.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/18/24.
//

import Foundation
import CoreData

class ToDoListManager {
    static let instance = ToDoListManager()
    let container:NSPersistentContainer
    let context: NSManagedObjectContext
    
    init() {
        container = NSPersistentContainer(name: "CoreDataContainer")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error loading Core Data. \(error)")
            }
        }
        context = container.viewContext
    }
    
    func saveData() {
        do {
            try context.save()
            print("Data has been saved.")
        } catch let error {
            print("Error saving Core Data. \(error.localizedDescription)")
        }
    }
}
