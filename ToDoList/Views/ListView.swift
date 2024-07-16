//
//  ListView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

struct ListView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @State private var showAlert = false
    @State private var folderName = ""
    @State private var folderIcon = "pencil"
    @State private var isSorted = false
    @State private var selection = sortByOptions.original
    
    let shadowColor: Color = .primary
    let shadowRadius: CGFloat = 10
    let shadowX: CGFloat = -7
    let shadowY: CGFloat = 7
    
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
        ZStack {
            if listViewModel.items.isEmpty && listViewModel.folders.isEmpty {
                NoItemsView()
                    .transition(AnyTransition.opacity.animation(.easeIn))
            } else {
                itemsView
            }
        }
        .navigationTitle("Just Do It! 📝")
        .toolbar { toolbarContent() }
        .onAppear {
            UNUserNotificationCenter.current().setBadgeCount(0)
            listViewModel.getData()
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
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) { menuItems }
        ToolbarItem(placement: .bottomBar) {
            HStack {
                NavigationLink(destination: AddView()) {
                    HStack {
                        Image(systemName: "plus.circle.fill")
                        Text("New Task")
                            .fontWeight(.bold)
                    }
                    .font(.title2)
                }
                
                Spacer()
                
                Button("New Folder") {
                    showAlert.toggle()
                }
                .font(.title3)
                .foregroundStyle(.accent)
                .alert("New Folder", isPresented: $showAlert) {
                    TextField("Enter folder name", text: $folderName)
                    Button("Create") {
                        listViewModel.addFolder(icon: folderIcon, title: folderName)
                        folderName = ""
                        print("Created")
                        print("\(listViewModel.folders)")
                    }
                    .disabled(folderName.isEmpty ? true : false)
                    
                    Button("Cancel", role: .cancel) {}
                }
            }
        }
    }
    
    private var itemsView: some View {
        List {
            LazyVGrid(columns: columns) {
                ForEach(listViewModel.folders) { folder in
                    Button {
                        
                    } label: {
                        FolderGridView(folder: folder)
                            .listRowSeparator(.hidden)
                            .listRowBackground(RoundedRectangle(cornerRadius: 10))
                            .foregroundStyle(Color.defaultItem)
                    }
                }
                .onDelete(perform: listViewModel.deleteFolder)
                .onMove(perform: listViewModel.moveFolder)
            }
            Text(listViewModel.items.isEmpty ? "" : "All")
                .font(.largeTitle)
                .fontWeight(.heavy)
                .listRowSeparator(.hidden)

            ForEach(isSorted ? listViewModel.sortedItems : listViewModel.items) { item in
                ListRowView(item: item)
                    .listRowSeparator(.hidden)
                    .listRowBackground(RoundedRectangle(cornerRadius: 10)
                                       //                        .foregroundStyle(item.dueDateSet ? NotificationManagerViewModel.instance.dueDateColor(date: item.dueDate) : Color.defaultItem)
                        .foregroundStyle(Color.defaultItem)
                        .addBorder(item.dueDateSet ? NotificationManagerViewModel.instance.dueDateColor(date: item.dueDate) : Color.primary, width: 3, cornerRadius: 10)
                        .padding(.horizontal)
                    )
                    .onTapGesture {
                        withAnimation(.linear) {
                            listViewModel.updateItem(item: item)
                        }
                    }
            }
            .onDelete(perform: listViewModel.deleteItem)
            .onMove(perform: listViewModel.moveItem)
        }
        .scrollIndicators(ScrollIndicatorVisibility.hidden)
        //.shadow(color: shadowColor, radius: shadowRadius, x: shadowX, y: shadowY)
        .listStyle(.plain)
        .listRowSpacing(15.0)    }
    
    private var menuItems: some View {
        Menu {
            Menu("Sort by") {
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
                    listViewModel.sortList(selection: newValue.rawValue)
                    
                }
                
            }
            NavigationLink("Settings") { SettingsView() }
        } label: {
            Image(systemName: "line.3.horizontal")
        }
    }
}
