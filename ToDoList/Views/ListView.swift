//
//  ListView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var isSorted = false
    @State private var selection = 0
    let filterOptions: [String] = [
        "Default", "Alphabetical", "Date"
    ]
    
    enum filters {
        case original, alphabetical, date
    }
    
    var body: some View {
        ZStack {
            if listViewModel.items.isEmpty {
                NoItemsView()
                    .transition(AnyTransition.opacity.animation(.easeIn))
            } else if isSorted {
                sortedItemsView
            } else {
                allItemsView
            }
        }
        .navigationTitle("Just Do It! 📝")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                menuItems
            }
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink("Add", destination: AddView())
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().setBadgeCount(0)
        }
    }
    
}


#Preview {
    NavigationStack {
        ListView()
    }
    .environmentObject(ListViewModel())
}

extension ListView {
    private var allItemsView: some View {
        List {
            ForEach(listViewModel.items) { item in
                ListRowView(item: item)
                    .onTapGesture {
                        withAnimation(.linear) {
                            listViewModel.updateItem(item: item)
                        }
                    }
                    .listRowSeparator(.hidden)
            }
            .onDelete(perform: listViewModel.deleteItem)
            .onMove(perform: listViewModel.moveItem)
        }
        .listStyle(.plain)
    }
    
    private var sortedItemsView: some View {
        List {
            ForEach(listViewModel.sortedItems) { item in
                ListRowView(item: item)
                    .onTapGesture {
                        withAnimation(.linear) {
                            listViewModel.updateItem(item: item)
                        }
                    }
            }
            .onDelete(perform: listViewModel.deleteItem)
            .onMove(perform: listViewModel.moveItem)
        }
        .listStyle(.plain)
    }
    
    private var menuItems: some View {
        Menu {
            Menu("Sort by") {
//                Button {
//                    isSorted = false
//                } label: {
//                    Image(systemName: !isSorted ? "checkmark" : "")
//                    Text("Default")
//                }
//                
//                Button {
//                    isSorted.toggle()
//                    listViewModel.sortByTitle()
//                } label: {
//                    Image(systemName: isSorted ? "checkmark" : "")
//                    Text("Alphabetical")
//                }
//                
//                Button {
//                    isSorted.toggle()
//                    listViewModel.sortByDate()
//                } label: {
//                    Image(systemName: isSorted ? "checkmark" : "")
//                    Text("Date")
//                }
                Picker("Menu", selection: $selection) {
                    ForEach(filterOptions.indices) { index in
                        Text(filterOptions[index])
                            .tag(filterOptions[index])
                    }
                }
                .onChange(of: selection) { oldValue, newValue in
                    
                }
                
            }
            NavigationLink("Settings") { SettingsView() }
        } label: {
            Image(systemName: "line.3.horizontal")
        }
    }
}


