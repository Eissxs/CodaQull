import Foundation
import UserNotifications

// MARK: - Notification Manager
/// Service para sa handling ng local notifications
/// Nag-se-setup ng daily reminders at notification permissions
class NotificationManager {
    // MARK: - Singleton Instance
    
    /// Shared instance para sa global access
    static let shared = NotificationManager()
    
    // MARK: - Properties
    
    /// Default notification time (10 AM)
    private let notificationHour = 10
    private let notificationMinute = 0
    
    // MARK: - Initialization
    
    private init() {}
    
    // MARK: - Public Methods
    
    /// Request notification permissions from user
    func requestPermissions() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            if granted {
                self.scheduleDailyNotification()
            }
            if let error = error {
                print("Error requesting notification permissions: \(error)")
            }
        }
    }
    
    /// Schedule daily notification at 10 AM
    func scheduleDailyNotification() {
        let center = UNUserNotificationCenter.current()
        
        // Remove existing notifications
        center.removeAllPendingNotificationRequests()
        
        // Create notification content
        let content = UNMutableNotificationContent()
        content.title = "CodaQuill Daily Reminder"
        content.body = "Time to check your code snippets and stay organized!"
        content.sound = .default
        
        // Create calendar components for 10 AM
        var dateComponents = DateComponents()
        dateComponents.hour = notificationHour
        dateComponents.minute = notificationMinute
        
        // Create trigger
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        // Create request
        let request = UNNotificationRequest(
            identifier: "dailyReminder",
            content: content,
            trigger: trigger
        )
        
        // Schedule notification
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
} 