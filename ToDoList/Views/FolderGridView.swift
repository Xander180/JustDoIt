//
//  FolderGridView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/16/24.
//

import SwiftUI

struct FolderGridView: View {
    let folder: FolderEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: folder.icon ?? "")
                
                Spacer()
                
                Text("\(folder.itemCount)")
                    .fontWeight(.heavy)
            }
            .font(.largeTitle)
            .padding(.bottom)
            
            Text(folder.title ?? "No Title")
                .font(.title)
        }
        .padding(7)
        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

//#Preview(traits: .sizeThatFitsLayout) {
//    FolderGridView(folder: FolderModel(icon: "sun.max.circle.fill",title: "Folder 1"))
//}
