//
//  NotificationManager.swift
//  ToDoList
//
//  Created by Wilson Ramirez on 7/10/24.
//

import Foundation
import SwiftUI
import UserNotifications

class NotificationManagerViewModel {
    static let instance = NotificationManagerViewModel() // Singleton
    
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
    
    func checkDate(date: Date) -> Color {
        if Calendar.current.isDateInToday(date) {
            return .red
        } else if Calendar.current.isDateInTomorrow(date) {
            return .yellow
        }
        return .green
        
        
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
