//
//  AlarmController.swift
//  Alarm
//
//  Created by XMS_JZhan on 1/28/19.
//  Copyright © 2019 XMS_JZhan. All rights reserved.
//

import UIKit
import UserNotifications

class AlarmController: AlarmScheduler {
    
    // Singleton
    static let shared = AlarmController()
    
    // Source of truth
    var alarms: [Alarm] = []
    
    var mockAlarms: [Alarm] {
        let first = Alarm.init(fireDate: Date.init(), name: "Morning", enabled: true)
        let second = Alarm.init(fireDate: Date.init(), name: "Afternoon", enabled: false)
        let third = Alarm.init(fireDate: Date.init(), name: "Night", enabled: true)
        
        return [first, second, third]
    }
    
    init() {
        self.alarms = self.mockAlarms
    }
    
    // MARK: - CRUD
    func addAlarm(fireDate: Date, name: String, isOn: Bool) {
        let alarm = Alarm.init(fireDate: fireDate, name: name, enabled: isOn)
        alarms.append(alarm)
        saveToPersistentStorage()
    }
    
    func update(alarm: Alarm, fireDate: Date, name: String, enabled: Bool) {
        alarm.fireDate = fireDate
        alarm.name = name
        alarm.enabled = enabled
        saveToPersistentStorage()
    }
    
    func delete(alarm: Alarm) {
        guard let index = alarms.index(of: alarm) else { return }
        alarms.remove(at: index)
        cancelUserNotifications(for: alarm)
        saveToPersistentStorage()
    }
    
    func toggleEnabled(for alarm: Alarm) {
        if alarm.enabled {
            cancelUserNotifications(for: alarm)
        } else {
            scheduleUserNotifications(for: alarm)
        }
        alarm.enabled = !alarm.enabled
        saveToPersistentStorage()
    }
    
    // MARK: - Persistence
    private static func fileURL() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = paths[0]
        let alarmLocation = "alarm.json"
        let url = documentDirectory.appendingPathComponent(alarmLocation)
        return url
    }
    
    private func saveToPersistentStorage() {
        let jsonEncoder = JSONEncoder()
        do {
            let data = try jsonEncoder.encode(alarms)
            try data.write(to: AlarmController.fileURL())
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
    
    func loadFromPersistentStorage() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: AlarmController.fileURL())
            alarms = try jsonDecoder.decode([Alarm].self, from: data)
        } catch let error {
            print("Error: \(error.localizedDescription)")
        }
    }
}

// MARK: - AlarmScheduler Protocol
protocol AlarmScheduler: class {
    func scheduleUserNotifications(for alarm: Alarm)
    func cancelUserNotifications(for alarm: Alarm)
}

extension AlarmScheduler {
    
    func scheduleUserNotifications(for alarm: Alarm) {
        let notification = UNMutableNotificationContent()
        notification.title = "\(alarm.name)"
        notification.body = "Time to wake up!"
        notification.sound = UNNotificationSound.default
        
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: alarm.fireDate)
        let notificationTrigger = UNCalendarNotificationTrigger.init(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest.init(identifier: alarm.uuid, content: notification, trigger: notificationTrigger)
        UNUserNotificationCenter.current().add(request) { (error : Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func cancelUserNotifications(for alarm: Alarm) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [alarm.uuid])
    }
}
