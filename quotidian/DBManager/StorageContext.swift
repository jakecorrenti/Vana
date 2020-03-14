//
//  StorageContext.swift
//  quotidian
//
//  Created by Jake Correnti on 2/24/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import RealmSwift

// storage abstraction layer
protocol StorageContext {
    
    // save an object that conforms to the Storable protocol
    func save(object: Storable) throws
    
    // delete an object that conforms to the Storable protocol
    func delete(object: Storable) throws
    
    // updates an object that conforms to the Object protocol (Realm Specific update style)
    func update(object: Object) throws
}
