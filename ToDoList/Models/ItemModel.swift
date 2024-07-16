//
//  ItemModel.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import Foundation

// Immutable Struct
struct ItemModel: Identifiable, Codable, Hashable {
    let id: String
    let title: String
    let createdDate: Date
    let dueDate: Date
    let dueDateSet: Bool
    let isCompleted: Bool
    let folder: String
    
    init(id: String = UUID().uuidString, title: String, createdDate: Date, dueDate: Date, dueDateSet: Bool, isCompleted: Bool, folderTag: String = "") {
        self.id = id
        self.title = title
        self.createdDate = createdDate
        self.dueDate = dueDate
        self.dueDateSet = dueDateSet
        self.isCompleted = isCompleted
        self.folder = folderTag
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, createdDate: createdDate, dueDate: dueDate, dueDateSet: dueDateSet, isCompleted: !isCompleted)
    }
    
    func addToFolder(folderName: String) -> ItemModel {
        return ItemModel(id: id, title: title, createdDate: createdDate, dueDate: dueDate, dueDateSet: dueDateSet, isCompleted: isCompleted, folderTag: folderName)
    }
}
