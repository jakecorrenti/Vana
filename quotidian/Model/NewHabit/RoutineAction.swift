//
//  RoutineAction.swift
//  quotidian
//
//  Created by Jake Correnti on 2/16/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import RealmSwift

class RoutineAction: Object {
    
    @objc dynamic var name                  = ""
    @objc dynamic var habit                 : Habit?
    @objc dynamic var isCompleted: Bool     = false
    @objc dynamic var completedDate: String = ""
    @objc dynamic var uid: String           = UUID().uuidString
    
    var daysCompleted = List<String>()
}
