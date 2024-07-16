//
//  ListViewModel.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 6/3/24.
//

import Foundation

/*
 CRUD Functions
 
 Create
 Read
 Update
 Delete
 
 */

class ListViewModel: ObservableObject {
    @Published var items: [ItemModel] = [] {
        didSet {
            saveItems()
        }
    }
    @Published var sortedItems: [ItemModel] = []
    
    @Published var folders: [FolderModel] = [] {
        didSet {
            saveFolders()
        }
    }
    
    let itemsKey = "items_list"
    let foldersKey = "folders_list"
    
    init() {
        getData()
        NotificationManagerViewModel.instance.getPendingNotifications()
    }
    
    // CREATE
    func addItem(title: String, dueDate: Date, dueDateSet: Bool) {
        let newItem = ItemModel(title: title, createdDate: Date.now, dueDate: dueDate, dueDateSet: dueDateSet, isCompleted: false)
        items.append(newItem)
    }
    
    func addFolder(icon: String, title: String) {
        let newFolder = FolderModel(icon: icon, title: title)
        folders.append(newFolder)
    }
    
    // READ
    func getData() {
        guard
            let itemData = UserDefaults.standard.data(forKey: itemsKey),
            let savedItems = try? JSONDecoder().decode([ItemModel].self, from: itemData),
            let folderData = UserDefaults.standard.data(forKey: foldersKey),
            let savedFolders = try? JSONDecoder().decode([FolderModel].self, from: folderData)
        else { return }
        
        self.items = savedItems
        self.folders = savedFolders
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    func moveFolder(from: IndexSet, to: Int) {
        folders.move(fromOffsets: from, toOffset: to)
    }
    
    // UPDATE
    func updateItem(item: ItemModel, folder: String = "") {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
            items[index] = item.addToFolder(folderName: folder)
            if items[index].isCompleted && SettingsView().deleteOnCompletion {
                deleteItem(indexSet: IndexSet(integer: index))
            }
        }
    }
    
    func saveItems() {
        if let encodedData = try? JSONEncoder().encode(items) {
            UserDefaults.standard.set(encodedData, forKey: itemsKey)
        }
    }
    
    func saveFolders() {
        if let encodedData = try? JSONEncoder().encode(folders) {
            UserDefaults.standard.set(encodedData, forKey: foldersKey)
        }
    }
    
    //DELETE
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func deleteAll() {
        items.removeAll()
        folders.removeAll()
    }
    
    func deleteFolder(indexSet: IndexSet) {
        folders.remove(atOffsets: indexSet)
    }
    
    func sortList(selection: String) {
        switch selection {
        case "Alphabetical":
            sortedItems.removeAll()
            sortedItems = items.sorted(by: { $0.title < $1.title})
        case "Date":
            sortedItems.removeAll()
            sortedItems = items.sorted(by: {$0.createdDate > $1.createdDate})
        default:
            getData()
        }
    }
}
