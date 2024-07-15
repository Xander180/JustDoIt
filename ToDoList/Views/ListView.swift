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
    @State var selection = sortByOptions.original
    
    let shadowColor: Color = .black.opacity(1)
    let shadowRadius: CGFloat = 10
    let shadowX: CGFloat = -5
    let shadowY: CGFloat = 5
    
    enum sortByOptions: String, CaseIterable, Identifiable {
        case original = "Default",
             alphabetical = "Alphabetical",
             date = "Date"
        
        var id: Self { self }
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
            ToolbarItem(placement: .topBarLeading) { menuItems }
            ToolbarItem(placement: .bottomBar) {  NavigationLink(destination: AddView()) {
                Image(systemName: "plus")
            }
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().setBadgeCount(0)
            listViewModel.getItems()
        }
        .onChange(of: listViewModel.items) { oldValue, newValue in
            listViewModel.sortList(selection: selection.rawValue)
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
                    .listRowBackground(RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(item.dueDateSet ? NotificationManagerViewModel.instance.checkDate(date: item.dueDate) : Color.white))
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
        .padding(.horizontal)
        .listRowSpacing(8.0)
    }
    
    private var sortedItemsView: some View {
        List {
            ForEach(listViewModel.sortedItems, id: \.self) { item in
                ListRowView(item: item)
                    .listRowBackground(RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(item.dueDateSet ? NotificationManagerViewModel.instance.checkDate(date: item.dueDate) : Color.white))
                    .onTapGesture {
                        withAnimation(.linear) {
                            listViewModel.updateItem(item: item)
                        }
                    }
            }
            .onDelete(perform: listViewModel.deleteItem)
            .onMove(perform: listViewModel.moveItem)
        }
    }
    
    private var menuItems: some View {
        Menu {
            Menu("Sort by") {
                Picker("Menu", selection: $selection) {
                    ForEach(sortByOptions.allCases, id: \.self) { option in
                        Text(option.rawValue)
                    }
                }
                .onChange(of: selection) { oldValue, newValue in
                    if selection.rawValue == "Default" {
                        isSorted = false
                    } else {
                        isSorted = true
                    }
                    listViewModel.sortList(selection: selection.rawValue)
                    
                }
                
            }
            NavigationLink("Settings") { SettingsView() }
        } label: {
            Image(systemName: "line.3.horizontal")
        }
    }
}
