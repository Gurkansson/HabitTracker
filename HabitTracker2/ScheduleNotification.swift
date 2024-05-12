//
//  ScheduleNotification.swift
//  HabitTracker2
//
//  Created by Frida on 2024-05-10.
//

import Foundation
import UIKit

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    var notificationManager = NotificationManager.shared
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
                     [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            granted,error in
            if granted {
                print("Notification permission granted")
            } else {
                print("Notification permission denied")
            }
        }
        return true
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler : @escaping ()-> Void){
        let notificationId = response.notification.request.identifier.prefix(36)
        notificationManager.handleNotification(notification:response.notification,id:String(notificationId))
        
        completionHandler()
    }
}

class Notification {
    func addNotification(content: UNMutableNotificationContent,dateComponents : DateComponents, id: String){
        //for testing progress
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: true)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request){ error in
            if let error = error {
                print ("Error scheduling notification: \(error.localizedDescription)")
            } else {
                print("Notification scheduled successfully")
            }
        }
    }
    /*func sheduleNotification(task : Tasks, time : Date) -> Int {
        var count = 0
        let content = UNMutableNotificationContent()
        content.title = "Reminder : Habbit Tracker"
        content.body = task.name
        content.sound = UNNotificationSound.default
        
        let date = Date()
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year,.month,.day], from: date)
        let components = calendar.dateComponents([.hour,.minute], from: time)
        
        dateComponents.hour = components.hour
        dateComponents.minute = components.minute
        dateComponents.second = 00
        
          for day in task.days{
         if task.frequencyType == FrequencyType.daily.rawValue{
         dateComponents.weekday = day
         for dayCount in 0..<task.frequency{
         let scheduledDate = calendar.date(byAdding: .day, value: dayCount, to: date)!
         
         let details = calendar.dateComponents([.year,.month,.day,.weekday], from: scheduledDate)
         if details.weekday == day{
         dateComponents.day = details.day
         dateComponents.month = details.month
         dateComponents.year = details.year
         
         addNotification(content: content, dateComponents: dateComponents, id: task.id.uuidString+"\(day)\(dayCount)")
         
         count += 1
         }
         }
         }else if task.frequencyType == FrequencyType.weekly.rawValue{
         dateComponents.weekday = day
         for dayCount in 0..<task.frequency*7{
         let scheduledDate = calendar.date(byAdding: .day, value: dayCount, to: date)!
         
         let details = calendar.dateComponents([.year,.month,.day,.weekday], from: scheduledDate)
         if details.weekday == day{
         dateComponents.day = details.day
         dateComponents.month = details.month
         dateComponents.year = details.year
         
         addNotification(content: content, dateComponents: dateComponents, id: task.id.uuidString+"\(day)\(dayCount)")
         
         count += 1
         }
         }
         } else {
         dateComponents.day = day
         for i in 0..<task.frequency{
         dateComponents.month = dateComponents.month! + i
         
         addNotification(content: content, dateComponents: dateComponents, id: task.id.uuidString+"\(day)\(i)")
         
         count+=1
         }
         }
         }
         return count
         }*/

}
