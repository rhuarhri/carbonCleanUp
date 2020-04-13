//
//  NotificationHandler.swift
//  carbonCleanUp
//
//  Created by DerbyMobile on 08/04/2020.
//  Copyright © 2020 DerbyMobile. All rights reserved.
//

import Foundation
import UserNotifications
import Firebase

class NotificationHandler {
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    private let lastUsed = Calendar.current.dateComponents([.hour,.minute,.second], from: Date())
    private let isRepeated = true
    private let id = "1"
    
    func displayNotification()
    {
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
        
        let collRef = Firestore.firestore().collection("message")
        
        collRef.getDocuments() { (querySnapshot, err) in
        if let err = err {
            print("Error getting documents: \(err)")
        } else {
            for document in querySnapshot!.documents {
                let result = document.data()
                
                let content = UNMutableNotificationContent()
                content.title = result["title"] as! String
                content.body = result["message"] as! String
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: self.lastUsed, repeats: self.isRepeated)
                
                let request = UNNotificationRequest(identifier: self.id, content: content, trigger: trigger)
                
                self.notificationCenter.add(request) { (error) in
                    //error handling
                }
                
            }
        }
        }

        
    }
    
    
}
