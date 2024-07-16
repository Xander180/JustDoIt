//
//  FolderModel.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/16/24.
//

import Foundation

struct FolderModel: Identifiable, Codable, Hashable {
    let id: String
    let icon: String
    let title: String
    var items: [ItemModel]
    var itemCount: Int
    
    init(id: String = UUID().uuidString, icon: String, title: String, items: [ItemModel] = [], itemCount: Int = 0) {
        self.id = id
        self.icon = icon
        self.title = title
        self.items = items
        self.itemCount = itemCount
    }
    
    mutating func addItem(newItem: ItemModel) -> FolderModel {
        self.items.append(newItem)
        self.itemCount = itemCount + 1
        return FolderModel(id: id, icon: icon, title: title, items: items, itemCount: itemCount)
    }
}
