//
//  NotificationManager.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/10/24.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManager {
    static let instance = NotificationManager() // Singleton
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                print("SUCCESS")
            }
        }
    }
    
    func scheduleNotification(subtitle: String, date: Date) {
        let content = UNMutableNotificationContent()
        content.title = "Task is due soon!"
        content.subtitle = "Test"
        content.sound = .default
        //content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        let dateComponents = DateComponents(year: date.get(.year), month: date.get(.month), day: date.get(.day))
        
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
    
    func getPendingNotifications() {
        UNUserNotificationCenter.current()
            .getPendingNotificationRequests(completionHandler: { requests in
                for (index, request) in requests.enumerated() {
                    print("notification: \(index) \(request.identifier) \(String(describing: request.trigger))")
                }
            })
    }
    
    func checkDueDate(date: Date) -> String {
        if Calendar.current.isDateInTomorrow(date) {
            return "Due tomorrow"
        } else if Calendar.current.isDateInToday(date) {
            return "Due today"
        } else if date.timeIntervalSinceNow.sign == .minus {
            return "Past due"
        }
        
        return ""
        
    }
    
    func dueDateColor(date: Date) -> Color {
        switch checkDueDate(date: date) {
        case "Due tomorrow":
            return .yellow
        case "Due today":
            return .red
        case "Past due":
            return .red
        default:
            return .green
        }
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
