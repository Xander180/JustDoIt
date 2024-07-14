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
    let dateCreated: Date
    let dateReminder: Date
    let reminderSet: Bool
    let isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, dateCreated: Date, dateReminder: Date, reminderSet: Bool, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.dateCreated = dateCreated
        self.dateReminder = dateReminder
        self.reminderSet = reminderSet
        self.isCompleted = isCompleted
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(title: title, dateCreated: dateCreated, dateReminder: dateReminder, reminderSet: reminderSet, isCompleted: isCompleted)
    }
}
