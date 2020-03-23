//
//  LocalNotificationsManager.swift
//  quotidian
//
//  Created by Jake Correnti on 2/27/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import UserNotifications

class LocalNotificationsManager {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var notifications = [LocalNotification]()
    
    // checks what local notifications have been scheduled
    func listScheduledNotifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            notifications.forEach {print($0)}
        }
    }
    
    // the number of notifications that have been scheduled
    func listNumberOfNotificationsScheduled() -> Int {
        var numberOfNotifications = 0
        var continueLooping = true
        
        var localNotifications = [UNNotificationRequest]()
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            for notification in notifications {
                localNotifications.append(notification)
            }
            continueLooping = false
        }
        
        while continueLooping {}
        
        numberOfNotifications = localNotifications.count
        
        return numberOfNotifications
    }
    
    // checks authorization to send noticications to the user or provides the prompt to allow them
    private func requestAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
            if granted && error == nil {
                self.scheduleNotifications()
            }
        }
    }
    
    // checks the user's authorization status
    func schedule() {
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            switch settings.authorizationStatus {
                case .notDetermined:
                    self.requestAuthorization()
                case .authorized, .provisional:
                    self.scheduleNotifications()
                default:
                    break // Do nothing
            }
        }
    }
    
    // iterates through the notifications in the array and schedules notifications accordingly 
    private func scheduleNotifications() {
        for notification in notifications {
            let content      = UNMutableNotificationContent()
            content.title    = notification.title
            content.sound    = .default

            var trigger: UNCalendarNotificationTrigger?
            
            if notification.isRepeating {
                trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateTime, repeats: true)
            } else {
                trigger = UNCalendarNotificationTrigger(dateMatching: notification.dateTime, repeats: false)
            }

            let request = UNNotificationRequest(identifier: notification.id, content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in

                guard error == nil else { return }

                print("Notification scheduled! --- ID = \(notification.id)")
            }
        }
    }
    
    // removes all of the pending notifications that the user has ongoing
    func removeAllPendingNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}
