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
    
    @State private var folderIcon = "pencil"
    @State private var folderIconColor: Color = .blue
    @State private var folderTitle = ""
    
    @State private var alertTitle = ""
    @State private var showAlert = false
    
    private let folderIcons: [String] = [
        "pencil", "archivebox", "mappin", "phone", "bookmark", "iphone.gen2"]
    
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
                    .scaledToFit()
                    .frame(width: 100, height: 100, alignment: .center)
                    .foregroundStyle(.white)
                    .padding()
                    .background(Circle().foregroundStyle(folderIconColor))
                TextField("Folder name", text: $folderTitle)
                    .padding(.horizontal)
                    .frame(height: 55)
                    .background(Color(UIColor.secondarySystemBackground))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                
                RectangularColorPickerView(colorValue: $folderIconColor)
                
                LazyVGrid(columns: columns) {
                    ForEach(folderIcons, id: \.self) { icon in
                        Image(systemName: icon)
                            .font(.title)
                            .padding()
                            .clipShape(Circle())
                            .overlay(Circle().strokeBorder(.black))
                            .onTapGesture {
                                folderIcon = icon
                            }
                    }
                }
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
            let red = Double(folderIconColor.components.r)
            let green = Double(folderIconColor.components.g)
            let blue = Double(folderIconColor.components.b)
            vm.addFolder(icon: folderIcon, title: folderTitle, r: red, g: green, b: blue)
            
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
