//
//  ListenersClass.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 07/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//
import FirebaseDatabase

@objc protocol repository : class {
    
    func add(snapshot: FIRDataSnapshot) -> Void
    func update(snapshot: FIRDataSnapshot, id: Any) -> Void
    func removed(snapshot: FIRDataSnapshot) -> Void
    @objc optional func removed(snapshot: Any, id: Any) -> Void
    @objc optional func get(snapshot: FIRDataSnapshot) -> Void
}
