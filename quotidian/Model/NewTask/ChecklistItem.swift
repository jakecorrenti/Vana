//
//  ChecklistItem.swift
//  quotidian
//
//  Created by Jake Correnti on 1/29/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import RealmSwift

class CheckListItem: Object {
    

    @objc dynamic var name        = ""
    @objc dynamic var isCompleted = false
    @objc dynamic var task: Task?
}
