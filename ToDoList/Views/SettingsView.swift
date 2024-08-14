//
//  SettingsView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 6/4/24.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var vm: CoreDataRelationshipViewModel
    
    @State var showAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                
            }
            .padding(14)
        }
        .navigationTitle("Settings ⚙️")
        
        Text("Alpha ver. 0.1.1 Build 3")
        
        Button("Delete All") {
            showAlert.toggle()
        }
        .foregroundStyle(Color.red)
        .confirmationDialog("WARNING", isPresented: $showAlert) {
            Button("Delete All", role: .destructive) {
                vm.deleteAll()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will delete ALL list items (not folders). Are you sure?")
        }
    }
}

//#Preview {
//    SettingsView()
//        .environmentObject(ListViewModel())
//}
