//
//  Task.swift
//  quotidian
//
//  Created by Jake Correnti on 1/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {

    @objc dynamic var title             = ""
    @objc dynamic var taskDescription   = ""
    @objc dynamic var reminderShortTime = ""
    @objc dynamic var reminderLongTime  = Date()
    
    var repeatDays     = List<String>()
    var checkListItems = List<CheckListItem>()
}
