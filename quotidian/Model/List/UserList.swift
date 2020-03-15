//
//  UserList.swift
//  quotidian
//
//  Created by Jake Correnti on 2/24/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class UserList: Object, Storable {
    @objc dynamic var name: String     = ""
    @objc dynamic var bgColorName: String = ""
    @objc dynamic var uid: String = UUID().uuidString
    var tasks = List<Task>()
    
    override class func primaryKey() -> String? {
        return "uid"
    }
    
    func append(task: Task) throws {
        var realm: Realm?
        do {
            try realm = Realm()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
        
        try realm?.write {
            tasks.append(task)
        }
    }
    
    func isInProgress() -> Bool {
        for task in self.tasks {
            if task.isCompleted {
                return true
            }
        }
        
        return false
    }
    
    func getTasksCompletedCount() -> Int {
        var completed = 0
        
        for task in self.tasks {
            if task.isCompleted {
                completed += 1
            }
        }
        
        return completed
    }
}
