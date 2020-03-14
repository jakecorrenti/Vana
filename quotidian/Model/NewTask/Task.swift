//
//  Task.swift
//  quotidian
//
//  Created by Jake Correnti on 1/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object, Storable {

    @objc dynamic var name              = ""
    @objc dynamic var notes             = ""
    @objc dynamic var reminderShortTime = ""
    @objc dynamic var reminderLongTime  = Date()
    @objc dynamic var uid               = "\(UUID())"
    @objc dynamic var isCompleted       = false
    @objc dynamic var completedDate     = ""
    @objc dynamic var userList: UserList?
    
    var repeatDays     = List<String>()
    var notificationID = List<String>()
    
    override class func primaryKey() -> String? {
        return "uid"
    }
    
    func updateCompletion(with status: Bool) throws {
        let object = realm?.objects(Task.self).filter("uid == '\(self.uid)'").first
        var realm: Realm?
        
        do {
            try realm = Realm()
        } catch {
            print("\(error.localizedDescription)")
        }
        
        try realm?.write {
            object?.isCompleted = status 
        }
        
    }
    
    func getRepeatingDayComponents() -> [Int] {
        var dayComponents = [Int]()
        
        for day in repeatDays {
            switch day {
            case "Sunday":
                dayComponents.append(1)
            case "Monday":
                dayComponents.append(2)
            case "Tuesday":
                dayComponents.append(3)
            case "Wednesday":
                dayComponents.append(4)
            case "Thursday":
                dayComponents.append(5)
            case "Friday":
                dayComponents.append(6)
            case "Saturday":
                dayComponents.append(7)
            default:
                continue
            }
        }
        return dayComponents
    }
    
    func getTaskHourComponent() -> Int {
        return Calendar.current.component(.hour, from: reminderLongTime)
    }
    
    func getTaskMinuteComponent() -> Int {
        return Calendar.current.component(.minute, from: reminderLongTime)
    }
    
    func getTaskDayOfMonthComponent() -> Int {
        return Calendar.current.component(.day, from: reminderLongTime)
    }
    
    func getTaskMonthComponent() -> Int {
        return Calendar.current.component(.month, from: reminderLongTime)
    }
    
}


