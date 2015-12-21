//
//  Task.swift
//  what.todo
//
//  Created by abhiram moturi on 12/19/15.
//  Copyright © 2015 abhiram moturi. All rights reserved.
//

//: Playground - noun: a place where people can play

import UIKit
import Foundation
import RealmSwift

var str = "Hello, playground"

class Task: Object{
    //MARK: properties
    dynamic var label: String = ""
    dynamic var id = 0
    dynamic var due: NSDate = NSDate()
    dynamic var notes: String = ""
    static var created: NSDate = NSDate()
    dynamic var isCompleted: Bool = false
    
    //MARK: methods
    override static func primaryKey() -> String? {
        return "id"
    }
    
    //initializer
    convenience required init(label: String, id: Int, due: NSDate, notes: String){
        self.init()
        self.label = label
        self.id = id
        self.due = due
        self.notes = notes
    }
    
    func update(label: String, due: NSDate, notes: String, isCompleted: Bool){
        
        self.realm?.beginWrite()
        
        self.label = label
        self.due = due
        self.notes = notes
        self.isCompleted = isCompleted
        
        try! self.realm?.commitWrite()
    }
    
    func updateLabel(label: String){
        self.update(label, due: self.due, notes: self.notes, isCompleted: self.isCompleted)
    }
    
    func updateDue(due: NSDate){
        self.update(self.label, due: due, notes: self.notes, isCompleted: self.isCompleted)
    }
    
    func updateNotes(notes: String){
        self.update(self.label, due: self.due, notes: notes, isCompleted: self.isCompleted)
    }
    
    func updateCompleted(isCompleted: Bool){
        self.update(self.label, due: self.due, notes: self.notes, isCompleted: isCompleted)
    }
    
    func save(){
        let realm = try! Realm()
        try! realm.write {
            realm.add(self, update: true)
        }
    }
    
}
