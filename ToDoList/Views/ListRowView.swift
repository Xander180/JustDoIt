//
//  ListRowView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

struct ListRowView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    let item: ItemModel
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.title)
                Spacer()
                Image(systemName: item.isCompleted ? "checkmark.circle" : "circle")
                    .font(.largeTitle)
                    //.foregroundStyle(item.isCompleted ? .green : .red)
            }
            .font(.title2)
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            // Allows entire cell to be tappable, as opposed to only the text and checkmark area
            .background(Color.black.opacity(0.001))
            
            if item.reminderSet {
                Text(dateFormatter.string(from: item.dateReminder))
                    .padding(.leading, 20)
                    .foregroundStyle(.secondary)
                    .font(.subheadline)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 5)
        .padding(.bottom, 10)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview(traits: .sizeThatFitsLayout) {
    Group {
        ListRowView(item: ItemModel(title: "This is the first item", dateCreated: Date.now, dateReminder: Date.now, reminderSet: false, isCompleted: false))
        ListRowView(item: ItemModel(title: "This is the second item", dateCreated: Date.now, dateReminder: Date.now, reminderSet: true, isCompleted: true))
    }
    .environmentObject(ListViewModel())
}
