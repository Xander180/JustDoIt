//
//  AddFolderView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/17/24.
//

import SwiftUI

struct AddFolderView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var vm: CoreDataRelationshipViewModel
    
    @State private var folderIcon = "pencil.circle.fill"
    @State private var folderIconColor = Color.blue
    @State private var folderTitle = ""
    
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil),
        GridItem(.flexible(), spacing: 6, alignment: nil)
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: folderIcon)
                    .resizable()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundStyle(folderIconColor)
                TextField("Folder name", text: $folderTitle)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                RectangularColorPickerView(colorValue: $folderIconColor)
            }
            .padding(14)
        }
        .navigationTitle("Create a Folder 📁")
        
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
            vm.addFolder(icon: folderIcon, title: folderTitle)
            
            dismiss.callAsFunction()
        }
    }
    
    func textIsNotEmpty() -> Bool {
        if folderTitle.isEmpty {
            alertTitle = "Text field must not be empty!"
            showAlert.toggle()
            return false
        }
        return true
    }
}


#Preview {
    NavigationStack {
        AddFolderView(vm: CoreDataRelationshipViewModel())
    }
}
