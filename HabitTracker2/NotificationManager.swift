//
//  NotificationManager.swift
//  HabitTracker2
//
//  Created by Frida on 2024-05-10.
//

import Foundation
import UserNotifications

class NotificationManager : ObservableObject {
    static let shared = NotificationManager()
    
    @Published var receivedNotification: UNNotification? = nil
    @Published var notificationID : String = ""
    
    func handleNotification(notification : UNNotification,id:String)
    {
        receivedNotification = notification
        notificationID = id
    }
}
