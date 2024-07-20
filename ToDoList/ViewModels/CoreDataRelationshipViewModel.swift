//
//  CoreDataRelationshipViewModel.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/18/24.
//

import Foundation
import SwiftUI
import CoreData

class CoreDataRelationshipViewModel: ObservableObject {
    let manager = ToDoListManager.instance
    @AppStorage("first_boot") var firstBoot = true
    @Published var items: [ItemEntity] = []
    @Published var folders: [FolderEntity] = []
    
    init() {
        if firstBoot {
            addDefaultFolders()
        }
        getItems()
        getFolders()
    }
    
    func getItems() {
        let request = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
        
        do {
            items = try manager.context.fetch(request)
            print("Items retrieved")
        } catch let error {
            print("Error fetching items. \(error.localizedDescription)")
        }
        
        
    }
    
    func getFolders() {
        let folderRequest = NSFetchRequest<FolderEntity>(entityName: "FolderEntity")
        
        do {
            folders = try manager.context.fetch(folderRequest)
        } catch let error {
            print("Error fetching items. \(error.localizedDescription)")
        }
    }
    
    func addItem(title: String, dateDue: Date, dateDueSet: Bool) {
        let newItem = ItemEntity(context: manager.context)
        newItem.title = title
        newItem.dateCreated = Date.now
        newItem.dateDue = dateDue
        newItem.dateDueSet = dateDueSet
        newItem.isCompleted = false
        
        
        saveData()
    }
    
    func addDefaultFolders() {
        let completedFolder = FolderEntity(context: manager.context)
        let allFolder = FolderEntity(context: manager.context)
        completedFolder.icon = "checkmark.seal.fill"
        completedFolder.title = "Completed"
        completedFolder.itemCount = 0
        
        allFolder.icon = "tray.circle.fill"
        allFolder.title = "All"
        allFolder.itemCount = 0
        
        firstBoot = false
        
        saveData()
    }
    
    func addFolder(icon: String, title: String) {
        let newFolder = FolderEntity(context: manager.context)
        newFolder.icon = icon
        newFolder.title = title
        newFolder.itemCount = 0
        
        saveData()
    }
    
    func saveData() {
        items.removeAll()
        folders.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.manager.saveData()
            self.getItems()
            self.getFolders()
        }
        
    }
}
