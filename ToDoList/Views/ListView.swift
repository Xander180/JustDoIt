//
//  ListView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

struct ListView: View {
    @StateObject var vm = CoreDataRelationshipViewModel()
    @State private var showAlert = false
    @State private var folderName = ""
    @State private var folderIcon = "pencil"
    @AppStorage("is_sorted") private var isSorted = false
    @AppStorage("sort_by") private var selection = sortByOptions.original
    
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    enum sortByOptions: String, CaseIterable, Identifiable {
        case original = "Default",
             alphabetical = "Alphabetical",
             date = "Date"
        
        var id: Self { self }
    }
    
    var body: some View {
        NavigationStack {
            VStack {
                itemsView
                if allItemsCompleted() {
                    NoItemsView(vm: vm)
                        .transition(AnyTransition.opacity.animation(.easeIn))
                }
            }
            .navigationTitle("Just Do It! 📝")
            .toolbar { toolbarContent() }
        }
    }
    
    func allItemsCompleted() -> Bool {
        for item in vm.items {
            if !item.isCompleted {
                return false
            }
        }
        
        return true
    }
}


#Preview {
    NavigationStack {
        ListView()
    }
    .environmentObject(ListViewModel())
}

extension ListView {
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) { menuItems }
        ToolbarItem(placement: .bottomBar) {
            HStack {
                if !allItemsCompleted() {
                    NavigationLink(destination: AddItemView(vm: vm)) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("New Task")
                                .fontWeight(.bold)
                        }
                        .font(.title2)
                    }
                }
                
                Spacer()
                
                NavigationLink(destination: AddFolderView(vm: vm)) {
                    Text("New Folder")
                        .font(.title3)
                        .foregroundStyle(.accent)
                }
            }
        }
    }
    
    private var itemsView: some View {
        List {
            @State var items = vm.items
            LazyVGrid(columns: columns) {
                ForEach(vm.folders) { folder in
                    FolderGridView(folder: folder)
                        .listRowSeparator(.hidden)
                        .foregroundStyle(Color.defaultItem)
                }
                .onDelete(perform: vm.deleteFolder)
//                .onMove(perform: listViewModel.moveFolder)
            }
            
            HStack {
                Text("All")
                    .font(.title)
                    .fontWeight(.heavy)
                .listRowSeparator(.hidden)
                
                Spacer()
                
                Menu("Sort by: \(selection.rawValue)") {
                    Picker("Menu", selection: $selection) {
                        ForEach(sortByOptions.allCases, id: \.self) { option in
                            Text(option.rawValue)
                        }
                    }
                    .onChange(of: selection) { oldValue, newValue in
                        if newValue == .original {
                            isSorted = false
                        } else {
                            isSorted = true
                        }
                        vm.sortItems(selection: newValue.rawValue)
                    }
                }
            }
            .listRowSeparator(.hidden)
            
            ForEach(isSorted ? vm.sortedItems : vm.items) { item in
                if !item.isCompleted {
                    ListRowView(item: item)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            withAnimation(.linear) {
                                vm.updateItem(item: item)
                            }
                        }
                }
            }
            .onDelete(perform: vm.deleteItem)
//            .onMove(perform: vm.moveItem)
        }
        .onAppear {
            vm.sortItems(selection: selection.rawValue)
        }
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .listStyle(.plain)
    }
    
    private var menuItems: some View {
        Menu {
            NavigationLink("Settings") { SettingsView() }
        } label: {
            Image(systemName: "line.3.horizontal")
        }
    }
}
