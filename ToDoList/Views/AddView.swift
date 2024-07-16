//
//  AddView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

struct AddView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var listViewModel: ListViewModel
    
    @State var showDueDate = false
    @State var scheduleNotification = false
    @State var showReminderOptions = false
    @State var dueDate: Date = Date.now
    
    @State var taskTitle = ""
    
    @State var alertTitle = ""
    @State var showAlert = false
    
    
    var body: some View {
        ScrollView {
            VStack {
                TextField("Type something here...", text: $taskTitle)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
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
                        
                        Toggle("Set Reminder", isOn: $scheduleNotification)
                            .onChange(of: scheduleNotification) { oldValue, newValue in
                                NotificationManagerViewModel.instance.requestAuthorization()
                            }
                    }
                }
            }
            .padding(14)
        }
        .navigationTitle("Add an Item 🖊️")
        
        Button(action: saveButtonPressed,
               label: {
            Text("Save".uppercased())
                .foregroundStyle(.white)
                .font(.headline)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .background(Color.accentColor)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        })
        .padding(14)
        .alert(alertTitle, isPresented: $showAlert) {
            
        }
    }
    
    func saveButtonPressed() {
        if textIsNotEmpty() {
            listViewModel.addItem(title: taskTitle, dueDate: dueDate, dueDateSet: showDueDate)
            if scheduleNotification {
                NotificationManagerViewModel.instance.scheduleNotification(subtitle: taskTitle ,date: dueDate)
            }
            dismiss.callAsFunction()
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
}

#Preview {
    NavigationStack {
        AddView()
    }
    .environmentObject(ListViewModel())
}
