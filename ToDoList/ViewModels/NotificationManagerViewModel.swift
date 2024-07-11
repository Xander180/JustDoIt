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
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = ""
        content.subtitle = ""
        content.sound = .default
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        
        var dateComponents = DateComponents()
        var repeatNotification = false
        dateComponents.hour = 0
        dateComponents.minute = 0
        dateComponents.weekday = 0
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: repeatNotification)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
