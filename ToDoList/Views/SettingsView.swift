//
//  SettingsView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 6/4/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("deleteOnCompletion") var deleteOnCompletion = false
    @State private var deleteTask = false
    
    var body: some View {
        ScrollView {
            VStack {
                Toggle("Delete Task On Completion", isOn: $deleteOnCompletion)
            }
            .padding(14)
        }
        .navigationTitle("Settings ⚙️")
    }
}

#Preview {
    SettingsView()
}
