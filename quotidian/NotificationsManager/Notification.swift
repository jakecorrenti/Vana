//
//  Notification.swift
//  quotidian
//
//  Created by Jake Correnti on 2/27/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import RealmSwift

struct LocalNotification {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var id: String
    var title: String
    var dateTime: DateComponents
    var isRepeating: Bool
}

class GeneralHabitNotification: Object, Storable {
    @objc dynamic var time: Date? = nil
}
