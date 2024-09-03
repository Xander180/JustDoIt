//
//  FolderView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/29/24.
//

import SwiftUI

struct FolderView: View {
    @ObservedObject var vm: CoreDataRelationshipViewModel
    let manager = ToDoListManager.instance
    let folder: FolderEntity
    @State var folderSelection: FolderEntity?
    @AppStorage("is_sorted") private var isSorted = false
    @AppStorage("sort_by") private var selection = ItemSortModel.Options.original
    
    var body: some View {
            List {
                ForEach(Array(folder.items as? Set<ItemEntity> ?? [])) { item in
                    NavigationLink(destination: AddItemView(vm: vm, item: item)) {
                        ListItemView(item: item)
                    }
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                withAnimation(.linear) {
                                    vm.isCompleted(item: item)
                                }
                            }
                            .onDelete {
                                vm.deleteItem(item: item)
                            }
                            .contextMenu {
                                Button("Mark Incomplete") {
                                    vm.isCompleted(item: item)
                                }
                                
                                Picker("Move to Folder", selection: $folderSelection) {
                                    ForEach(vm.folders, id: \.self) { folder in
                                        if folder.title != "Completed" && !folder.items!.contains(item) {
                                            Text(folder.title ?? "").tag(Optional(folder))
                                                .onChange(of: folderSelection) { oldValue, newValue in
                                                    vm.addToFolder(item: item, folder: folderSelection!)
                                                }
                                            
                                        }
                                    }
                                }
                                .pickerStyle(.menu)
                                
                                NavigationLink("Edit", destination: AddItemView(vm: vm, item: item))
                                
                                Button("Delete") {
                                    vm.deleteItem(item: item)
                                }
                            }
                }
                //            .onMove(perform: vm.moveItem)
            }
            .onAppear {
                vm.sortItems(selection: selection.rawValue)
            }
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
            .listStyle(.plain)
            .navigationTitle(folder.title ?? "Folder")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
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
            }
    }
}

#Preview {
    FolderView(vm: CoreDataRelationshipViewModel(), folder: FolderEntity(context: ToDoListManager.instance.context))
}
