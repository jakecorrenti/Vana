//
//  RealmStorageContext.swift
//  quotidian
//
//  Created by Jake Correnti on 2/24/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import Foundation
import RealmSwift

class RealmStorageContext: StorageContext {
    
    var realm: Realm?
    
    func save(object: Storable) throws {
        do {
            try realm = Realm()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
        
        try realm?.write {
            realm?.add(object as! Object)
        }
    }
    
    func delete(object: Storable) throws {
        do {
            try realm = Realm()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
        
        try realm?.write {
            realm?.delete(object as! Object)
        }
    }
    
    func update(object: Object) throws {
        do {
            try realm = Realm()
        } catch {
            fatalError("\(error.localizedDescription)")
        }
        
        try realm?.write {
            realm?.add(object, update: .modified)
        }
    }
}

