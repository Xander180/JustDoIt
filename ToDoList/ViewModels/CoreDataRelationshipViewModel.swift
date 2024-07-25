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
    @Published var sortedItems: [ItemEntity] = []
    @Published var folders: [FolderEntity] = []
    
    init() {
        if firstBoot {
            addDefaultFolders()
            sortedItems = items
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
        newItem.addToFolders(folders[1])
        
        
        
        saveData()
    }
    
    func updateItem(item: ItemEntity) {
        item.isCompleted.toggle()
        
        if let folderIndex = folders.firstIndex(where: { $0.title == "Completed" }) {
            if item.isCompleted {
                folders[folderIndex].addToItems(item)
            } else {
                folders[folderIndex].removeFromItems(item)
            }
        }
        
        if item.isCompleted {
            items.removeAll(where: {$0.id == item.id} )
        } else {
            items.append(item)
        }
        
        saveData()
    }
    
    func addDefaultFolders() {
        let completedFolder = FolderEntity(context: manager.context)
        let allFolder = FolderEntity(context: manager.context)
        completedFolder.icon = "checkmark.seal.fill"
        completedFolder.title = "Completed"
        
        allFolder.icon = "tray.circle.fill"
        allFolder.title = "All"
        
        firstBoot = false
        
        saveData()
    }
    
    func addFolder(icon: String, title: String) {
        let newFolder = FolderEntity(context: manager.context)
        newFolder.icon = icon
        newFolder.title = title
        
        saveData()
    }
    
    func deleteItem(indexSet: IndexSet) {
        let index = indexSet[indexSet.startIndex]
        manager.context.delete(items[index])
        saveData()
    }
    
    func deleteFolder(indexSet: IndexSet) {
        let index = indexSet[indexSet.startIndex]
        manager.context.delete(folders[index])
        saveData()
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
        saveData()
    }
    
    func moveFolder(from: IndexSet, to: Int) {
        folders.move(fromOffsets: from, toOffset: to)
        saveData()
    }
    
    func sortItems(selection: String){
        _ = NSFetchRequest<ItemEntity>(entityName: "ItemEntity")
        
        switch selection {
        case "Alphabetical":
            sortedItems = items.sorted(by: { $0.title! < $1.title! })
        case "Date":
            sortedItems = items.sorted(by: { $0.dateCreated ?? Date() > $1.dateCreated ?? Date()} )
        default:
            sortedItems = items
        }

        saveData()
    }
    
    func saveData() {
        items.removeAll()
        folders.removeAll()
        
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.manager.saveData()
            self.getItems()
            self.getFolders()
        }
        
    }
}
