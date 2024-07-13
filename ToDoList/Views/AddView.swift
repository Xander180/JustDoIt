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
    
    @State var scheduleNotification = false
    @State var showReminderOptions = false
    @State var selectedDate: Date = Date.now
    
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
                    Toggle("Set Reminder", isOn: $scheduleNotification)
                        .onChange(of: scheduleNotification) { oldValue, newValue in
                            showReminderOptions.toggle()
                        }
                    if showReminderOptions {
                        withAnimation(.bouncy) {
                            DatePicker("Set a Reminder", selection: $selectedDate, displayedComponents: [.date, .hourAndMinute])
                                .onAppear(perform: {
                                    NotificationManagerViewModel.instance.requestAuthorization()
                                })
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
            listViewModel.addItem(title: taskTitle, date: selectedDate, dateSet: scheduleNotification)
            if showReminderOptions {
                NotificationManagerViewModel.instance.scheduleNotification(subtitle: taskTitle ,date: selectedDate)
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
