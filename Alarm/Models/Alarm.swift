//
//  Alarm.swift
//  Alarm
//
//  Created by XMS_JZhan on 1/28/19.
//  Copyright © 2019 XMS_JZhan. All rights reserved.
//

import UIKit

class Alarm: Codable {
    var fireDate: Date
    var name: String
    var enabled: Bool
    let uuid: String
    var fireTimeAsString: String {
        get {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .none
            dateFormatter.timeStyle = .short
            
            dateFormatter.locale = Locale(identifier: "en_US")
            return dateFormatter.string(from: fireDate)
        }
    }
    
    init(fireDate: Date, name: String, enabled: Bool) {
        self.fireDate = fireDate
        self.name = name
        self.enabled = enabled
        self.uuid = UUID().uuidString
    }
}

extension Alarm: Equatable {
    static func == (lhs: Alarm, rhs: Alarm) -> Bool {
        return lhs.fireDate == rhs.fireDate && lhs.name == rhs.name && lhs.uuid == rhs.uuid
    }
}
