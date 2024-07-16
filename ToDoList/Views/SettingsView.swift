//
//  SettingsView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 6/4/24.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @AppStorage("deleteOnCompletion") var deleteOnCompletion = false
    
    @State var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Toggle("Delete Task On Completion", isOn: $deleteOnCompletion)
            }
            .padding(14)
        }
        .navigationTitle("Settings ⚙️")
        
        Text("Build ver. 0.1.0")
        
        Button("Delete All") {
            showAlert.toggle()
        }
        .foregroundStyle(Color.red)
        .confirmationDialog("WARNING", isPresented: $showAlert) {
            Button("Delete All", role: .destructive) {
                listViewModel.deleteAll()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete all list items. Are you sure?")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(ListViewModel())
}
