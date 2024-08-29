//
//  ListView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var vm = CoreDataRelationshipViewModel()
    @State private var showAlert = false
    @AppStorage("is_sorted") private var isSorted = false
    @AppStorage("sort_by") private var selection = ItemSortModel.Options.original
    
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
    ]
    
    var body: some View {
        ScrollView {
                LazyVStack {
                    foldersView
                    itemsView
                    if allItemsCompleted() {
                        NoItemsView(vm: vm)
                            .transition(AnyTransition.opacity.animation(.easeIn))
                    }
                }
                .navigationTitle("Just Do It! 📝")
                .toolbar { toolbarContent() }
        }
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        .listStyle(.plain)
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
        MainView()
    }
}

extension MainView {
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
    
    private var foldersView: some View {
        LazyVGrid(columns: columns) {
            ForEach(vm.folders) { folder in
                NavigationLink(destination: FolderView(vm: vm, folder: folder)) {
                    ListFolderView(folder: folder)
                        .listRowSeparator(.hidden)
                        .foregroundStyle(Color.defaultItem)
                }
                .contextMenu {
                    Button("Edit Folder") {
                        
                    }
                    Button("Delete Folder") {
                        vm.deleteFolder(folder: folder)
                    }
                }
            }
            //                .onMove(perform: listViewModel.moveFolder)
        }
        .padding(.horizontal)
    }
    
    private var itemsView: some View {
        VStack {
            HStack {
                Text("All")
                    .font(.title)
                    .fontWeight(.heavy)
                .listRowSeparator(.hidden)
                
                Spacer()
                
                Menu("Sort by: \(selection.rawValue)") {
                    Picker("Menu", selection: $selection) {
                        ForEach(ItemSortModel.Options.allCases, id: \.self) { option in
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
                    ListItemView(item: item)
                        .listRowSeparator(.hidden)
                        .onTapGesture {
                            withAnimation(.linear) {
                                vm.updateItem(item: item)
                            }
                        }
                        .onDelete {
                            vm.deleteItem(item: item)
                        }
                        .contextMenu {
                            Button("Mark Completed") {
                                vm.updateItem(item: item)
                            }
                            
                            Button("Edit") {
                                
                            }
                            
                            Button("Delete") {
                                vm.deleteItem(item: item)
                            }
                        }
                }
            }
//            .onMove(perform: vm.moveItem)
        }
        .onAppear {
            vm.sortItems(selection: selection.rawValue)
        }
        .padding()

    }
    
    private var menuItems: some View {
        Menu {
            NavigationLink("Settings") { SettingsView(vm: vm) }
        } label: {
            Image(systemName: "line.3.horizontal")
        }
    }
}
