//
//  ToDoListApp.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

/*
 MVVM Architecture
 
 Model - Data Point
 View - UI
 ViewModel - Manages models for View
 
 */

@main
struct ToDoListApp: App {
    @StateObject var listViewModel: ListViewModel = ListViewModel()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                MainView()
            }
            .environmentObject(listViewModel)
        }
    }
}
