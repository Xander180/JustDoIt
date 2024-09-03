//
//  AddView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

struct AddItemView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: CoreDataRelationshipViewModel
    var item: ItemEntity?
    
    @State private var editMode = true
    
    @State private var showDueDate = false
    @State private var setReminder = false
    @State private var showReminderOptions = false
    @State private var dueDate: Date = Date.now
    
    @State private var taskTitle = ""
    @State private var taskNote = ""
    @State private var selectedFolder = ""
    @State private var addToFolder: FolderEntity?
    
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    
    var body: some View {
        Form {
            TextField("Task title", text: $taskTitle)
                .onAppear {
                    taskTitle = item?.title ?? taskTitle
                }
                .disabled(editMode != true ? true : false)
                
            TextField("Notes", text: $taskNote, axis: .vertical)
                    .multilineTextAlignment(.leading)
                    .onAppear {
                        taskNote = item?.note ?? taskNote
                    }
                    .disabled(editMode != true ? true : false)
                
                VStack(spacing: 20) {
                    Toggle("Due Date", isOn: $showDueDate)
                        .onChange(of: showDueDate) { oldValue, newValue in
                            showReminderOptions.toggle()
                        }
                    
                    if showReminderOptions {
                        withAnimation(.easeIn) {
                            DatePicker("Due date", selection: $dueDate, displayedComponents: [.date, .hourAndMinute])
                                .labelsHidden()
                        }
                        
                        Toggle("Set Reminder", isOn: $setReminder)
                            .onChange(of: setReminder) { oldValue, newValue in
                                NotificationManager.instance.requestAuthorization()
                            }
                    }
                }
                .onAppear {
                    if item?.dateDueSet != nil {
                        showDueDate = item!.dateDueSet
                        setReminder = item!.setReminder
                    }
                    dueDate = item?.dateDue ?? Date.now
                }
                .disabled(editMode != true ? true : false)
            
            // TODO: Load selected folder for existing task
            Picker("Folder", selection: $addToFolder) {
                Text("None").tag(nil as FolderEntity?)
                ForEach(vm.folders, id: \.self) {
                    if $0.title != "Completed" {
                        Text($0.title ?? "").tag(Optional($0))
                    }
                }
            }
            .pickerStyle(.menu)
            .onChange(of: addToFolder) { oldValue, newValue in
                selectedFolder = addToFolder?.title ?? "None"
            }
            .disabled(editMode != true ? true : false)

        }
        .navigationTitle("Add an Item 🖊️")
        .listStyle(.plain)
        .onChange(of: vm.items) { oldValue, newValue in
            vm.getItems()
        }
        .onAppear {
            if item != nil {
                editMode = false
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if item != nil {
                    Button(editMode == false ? "Edit" : "Undo") {
                        if editMode {
                            undoEdit()
                        }
                        editMode.toggle()
                    }
                }
            }
        }
        
        if editMode {
            Button(action: saveButtonPressed,
                   label: {
                Text("Save".uppercased())
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(width: 350, height: 55)
//                    .frame(maxWidth: 500)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            .padding(14)
            .alert(alertTitle, isPresented: $showAlert) {
                
            }
        } else {
            Button(action: {vm.isCompleted(item: item!)}, label: {
                Text(item?.isCompleted ?? false ? "Mark Incomplete".uppercased() : "Mark Completed".uppercased())
                    .foregroundStyle(.white)
                    .font(.headline)
                    .frame(width: 350, height: 55)
//                    .frame(maxWidth: 400)
                    .background(Color.accentColor)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            })
            .padding(14)
            .alert(alertTitle, isPresented: $showAlert) {
            }
        }
    }
    
    func saveButtonPressed() {
        if textIsNotEmpty() {
            if item == nil {
                vm.addItem(title: taskTitle, note: taskNote, dateDue: dueDate, dateDueSet: showDueDate, toFolder: addToFolder, setReminder: setReminder)
            } else {
                vm.updateItem(item: item!, title: taskTitle, note: taskNote, dateDue: dueDate, dateDueSet: showDueDate, toFolder: addToFolder, setReminder: setReminder)
            }
            if setReminder {
                NotificationManager.instance.scheduleNotification(subtitle: taskTitle ,date: dueDate)
            }
//            dismiss.callAsFunction()
            editMode = false
        }
    }
    
    func textIsNotEmpty() -> Bool {
        if taskTitle.isEmpty {
            alertTitle = "Text field must not be empty!"
            showAlert.toggle()
            return false
        }
       return true
    }
    
    func undoEdit() {
        taskTitle = item!.title!
        taskNote = item!.note!
        showDueDate = item!.dateDueSet
        setReminder = item!.setReminder
    }
}

#Preview {
    NavigationStack {
        AddItemView(vm: CoreDataRelationshipViewModel())
    }
}
