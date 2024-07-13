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
    let date: Date
    let dateSet: Bool
    let isCompleted: Bool
    
    init(id: String = UUID().uuidString, title: String, date: Date, dateSet: Bool, isCompleted: Bool) {
        self.id = id
        self.title = title
        self.date = date
        self.dateSet = dateSet
        self.isCompleted = isCompleted
    }
    
    func updateCompletion() -> ItemModel {
        return ItemModel(id: id, title: title, date: date, dateSet: dateSet, isCompleted: !isCompleted)
    }
}
