//
//  NotificationService.swift
//  kursova
//
//  Created by Artem Leschenko on 09.05.2023.
//

import Foundation
import UserNotifications
import UIKit

class NotificationService {
    private var language = LocalizationService.shared.language
    private init () { }
    
    static let shared = NotificationService()
    
    
    func makeNotification(name: String, id: String, profile: String) {
            language = LocalizationService.shared.language
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1800.0, repeats: false)
            let content = UNMutableNotificationContent()
            content.title = "Dear ".localized(language) + profile + "!"
            content.body = "Time to check your bid for the lot \"".localized(language) + name + "\" by ID: \n".localized(language) + id
            content.sound = .default
            let currentBadgeNumber = UIApplication.shared.applicationIconBadgeNumber
            content.badge = NSNumber(value: currentBadgeNumber + 1)

            let request = UNNotificationRequest(identifier: "stavka", content: content, trigger: trigger)

            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("Ошибка добавления уведомления: \(error)")
                } else {
                    print("Уведомление успешно добавлено")
                }
            }
    }
}
