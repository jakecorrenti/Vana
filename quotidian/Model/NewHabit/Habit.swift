//
//  Habit.swift
//  quotidian
//
//  Created by Jake Correnti on 2/16/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import RealmSwift

class Habit: Object, Storable {
    
    @objc dynamic var name: String          = ""
    @objc dynamic var cue: String           = ""
    @objc dynamic var reward: String        = ""
    @objc dynamic var uid: String           = UUID().uuidString
    @objc dynamic var isCompleted: Bool     = false
    @objc dynamic var completedDate: String = ""
    
    var originalRoutine = List<RoutineAction>()
    var updatedRoutine  = List<RoutineAction>()
}
