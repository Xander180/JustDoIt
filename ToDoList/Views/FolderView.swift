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
    @AppStorage("is_sorted") private var isSorted = false
    @AppStorage("sort_by") private var selection = ItemSortModel.Options.original
    
    var body: some View {
            List {
                ForEach(Array(folder.items as? Set<ItemEntity> ?? [])) { item in
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
