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
        "pencil", "scribble.variable", "archivebox.fill", "bookmark.fill", "book.fill", "mappin", "house.fill", "building.fill", "phone.fill", "display", "iphone.gen2", "gamecontroller.fill", "lock.doc.fill", "exclamationmark.triangle.fill", "shield.lefthalf.filled", "heart.fill", "stethoscope", "cross.case.fill", "sun.max.fill", "moon.fill", "flame.fill", "bolt.fill", "dog.fill", "cat.fill", "lizard.fill", "fish.fill", "leaf.fill", "camera.macro", "tree.fill", "dumbbell.fill", "soccerball", "basketball.fill", "baseball.fill", "football.fill", "tennis.racket", "cart.fill", "basket.fill", "dollarsign", "creditcard.fill", "compass.drawing","lightbulb.fill", "message.fill", "circle.fill", "square.fill", "triangle.fill", "diamond.fill", "star.fill"]
    
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
                
                iconPickerView
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

extension AddFolderView {
    private var iconPickerView: some View {
        LazyVGrid(columns: columns) {
            ForEach(folderIcons, id: \.self) { icon in
                Image(systemName: icon)
                    .font(.title)
                    .padding()
                    .clipShape(Circle())
                    .overlay(Circle().strokeBorder(.black).frame(width: 50, height: 50))
                    .onTapGesture {
                        folderIcon = icon
                    }
            }
        }
    }
}
