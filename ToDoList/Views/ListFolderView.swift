//
//  FolderGridView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/16/24.
//

import SwiftUI

struct ListFolderView: View {
    let folder: FolderEntity
//    @State var itemCount = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                let folderIconColor = Color(red: folder.iconColorR, green: folder.iconColorG, blue: folder.iconColorB, opacity: folder.iconColorA)
                Image(systemName: folder.icon ?? "pencil")
                    .foregroundStyle(.white)
                    .padding()
                    .background(Circle().foregroundStyle(folderIconColor))
                
                Spacer()
                
//                Text("\(folder.items?.count ?? 0)")
//                    .fontWeight(.heavy)
            }
//            .onChange(of: folder.items?.count, { oldValue, newValue in
//                itemCount = folder.items?.count ?? 0
//                
//            })
            .font(.largeTitle)
            .padding(.bottom)
            
            Text(folder.title ?? "No Title")
                .font(.title)
                .foregroundStyle(.black)
                .lineLimit(1)
                .allowsTightening(false)
        }
        .padding(7)
//        .background(Color.gray)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(RoundedRectangle(cornerRadius: 10).strokeBorder(.black, lineWidth: 1))
    }
}

//#Preview(traits: .sizeThatFitsLayout) {
//    ListFolderView(folder: FolderEntity(context: ToDoListManager.instance.context))
//}
