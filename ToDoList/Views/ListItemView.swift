//
//  ListRowView.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 5/31/24.
//

import SwiftUI

struct ListItemView: View {
    let item: ItemEntity
    
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(item.title ?? "NO TITLE")
                Spacer()
                Image(systemName: item.isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.largeTitle)
                    .background(Color.white)
                    .clipShape(Circle())
                    //.addBorder(Color.black, width: 2, cornerRadius: 20)
            }
            .font(.title2)
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            // Allows entire cell to be tappable, as opposed to only the text and checkmark area
            .background(Color.black.opacity(0.001))
            
            
            if item.dateDueSet {
                HStack {
                    Text(dateFormatter.string(from: item.dateDue ?? Date.now))
                        .padding(.leading, 20)
                        .foregroundStyle(.secondary)
                        .font(.subheadline)
                    
                    Text(NotificationManager.instance.checkDueDate(date: item.dateDue ?? Date.now))
                        .fontWeight(.bold)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 5)
        .padding(.bottom, 10)
        .background(item.dateDueSet ? NotificationManager.instance.dueDateColor(date: item.dateDue ?? Date.now) : Color.defaultItem)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .addBorder(item.dateDueSet ? NotificationManager.instance.dueDateColor(date: item.dateDue ?? Date.now) : Color.primary, width: 1, cornerRadius: 10)
        
    }
}

//#Preview(traits: .sizeThatFitsLayout) {
//    ListRowView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
