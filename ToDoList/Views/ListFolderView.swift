//
//  FolderGridView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/16/24.
//

import SwiftUI

struct ListFolderView: View {
    let folder: FolderEntity
    @State var itemCount = 0
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: folder.icon ?? "pencil")
                
                Spacer()
                
                Text("\(folder.items?.count ?? 0)")
                    .fontWeight(.heavy)
            }
            .onChange(of: folder.items?.count, { oldValue, newValue in
                itemCount = folder.items?.count ?? 0
            })
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

#Preview(traits: .sizeThatFitsLayout) {
    ListFolderView(folder: FolderEntity(context: ToDoListManager.instance.context))
}
