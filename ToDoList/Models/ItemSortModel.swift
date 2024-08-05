//
//  SortByOptionsModel.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/29/24.
//

import Foundation

class ItemSortModel {
    enum Options: String, CaseIterable, Identifiable {
        case original = "Default",
             alphabetical = "Alphabetical",
             date = "Date"
        
        var id: Self { self }
    }
}
