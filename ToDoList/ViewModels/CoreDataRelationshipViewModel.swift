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
    
    func addItem(title: String, note: String, dateDue: Date, dateDueSet: Bool, toFolder: FolderEntity?) {
        let newItem = ItemEntity(context: manager.context)
        newItem.title = title
        newItem.note = note
        newItem.dateCreated = Date.now
        newItem.dateDue = dateDue
        newItem.dateDueSet = dateDueSet
        newItem.isCompleted = false
        
        if toFolder != nil {
            addToFolder(item: newItem, folder: toFolder!)
        }

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
    
    func addToFolder(item: ItemEntity, folder: FolderEntity) {
        item.addToFolders(folder)
        
        saveData()
    }
    
    func addDefaultFolders() {
        let completedFolder = FolderEntity(context: manager.context)
        completedFolder.icon = "checkmark"
        completedFolder.title = "Completed"
        completedFolder.iconColorR = 0
        completedFolder.iconColorG = 0
        completedFolder.iconColorB = 0
        completedFolder.iconColorA = 1
        
        firstBoot = false
        
        saveData()
    }
    
    func addFolder(icon: String, title: String, r: Double, g: Double, b: Double, a: Double = 1) {
        let newFolder = FolderEntity(context: manager.context)
        newFolder.icon = icon
        newFolder.title = title
        newFolder.iconColorR = r
        newFolder.iconColorG = g
        newFolder.iconColorB = b
        newFolder.iconColorA = a
        
        saveData()
    }
    
//    func deleteItem(indexSet: IndexSet) {
//        let index = indexSet[indexSet.startIndex]
//        manager.context.delete(items[index])
//        saveData()
//    }
    
    func deleteItem(item: ItemEntity) {
        manager.context.delete(item)
        saveData()
    }
    
    func deleteFolder(folder: FolderEntity) {
        manager.context.delete(folder)
        saveData()
    }
    
    func deleteAll() {
        var fetchRequest: NSFetchRequest<NSFetchRequestResult>
        var deleteRequest: NSBatchDeleteRequest
        
        do {
            fetchRequest = NSFetchRequest(entityName: "ItemEntity")
            deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            
            try manager.context.execute(deleteRequest)
        } catch let error as NSError {
            print("Items could not be deleted. \(error.localizedDescription)")
        }
        
//        do {
//            fetchRequest = NSFetchRequest(entityName: "FolderEntity")
//            deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
//            
//            try manager.context.execute(deleteRequest)
//        } catch let error as NSError {
//            print("Folders could not be deleted")
//        }
        
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
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            self.manager.saveData()
            self.getItems()
            self.getFolders()
        }
        
    }
}
