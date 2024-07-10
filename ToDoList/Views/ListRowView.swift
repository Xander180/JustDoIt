//
//  ListRowView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

struct ListRowView: View {
    let item: ItemModel
    
    var body: some View {
        HStack {
            Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                .foregroundStyle(item.isCompleted ? .green : .red)
            Text(item.title)
            Spacer()
        }
        .font(.title2)
        .padding(.vertical, 8)
        // Allows entire cell to be tappable, as opposed to only the text and checkmark area
        .background(Color.black.opacity(0.001))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        ListRowView(item: ItemModel(title: "This is the first item", isCompleted: false))
        ListRowView(item: ItemModel(title: "This is the second item", isCompleted: true))
    }
}
