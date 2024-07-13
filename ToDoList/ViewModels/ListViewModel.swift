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
    
    let itemsKey = "items_list"
    
    init() {
        getItems()
        NotificationManagerViewModel.instance.getPendingNotifications()
    }
    
    // CREATE
    func addItem(title: String, date: Date, dateSet: Bool) {
        let newItem = ItemModel(title: title, date: date, dateSet: dateSet, isCompleted: false)
        items.append(newItem)
    }
    
    // READ
    func getItems() {
        guard
            let data = UserDefaults.standard.data(forKey: itemsKey),
                let savedItems = try? JSONDecoder().decode([ItemModel].self, from: data)
        else { return }
        
        self.items = savedItems
    }
    
    func moveItem(from: IndexSet, to: Int) {
        items.move(fromOffsets: from, toOffset: to)
    }
    
    // UPDATE
    func updateItem(item: ItemModel) {
        if let index = items.firstIndex(where: { $0.id == item.id }) {
            items[index] = item.updateCompletion()
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
    
    //DELETE
    func deleteItem(indexSet: IndexSet) {
        items.remove(atOffsets: indexSet)
    }
    
    func sortList(selection: String) {
        switch selection {
        case "Alphabetical":
            sortedItems.removeAll()
            sortedItems = items.sorted(by: { $0.title < $1.title})
        case "Date":
            sortedItems.removeAll()
            sortedItems = items.sorted(by: {$0.date > $1.date})
        default:
            getItems()
        }
        
    }
}
