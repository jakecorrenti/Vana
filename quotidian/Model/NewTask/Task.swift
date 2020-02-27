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
}


