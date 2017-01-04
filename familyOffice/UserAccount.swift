//
//  UserAccount.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 03/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import FirebaseDatabase

extension user
{
    
    static var firebaseChildKey: String { return "user" }
    
    static func fromSnapshot(snapshot: FIRDataSnapshot) -> user? {
        
        if (snapshot.exists()) {
            
            let name = snapshot.value?["name"] as? String
            let email = snapshot.value?["email"] as? String
            let phone = snapshot.value?["phone"] as? Int
            
            return user(
                name: name,
                email: email,
                phone: phone)
        }
        
        return nil
    }
    
    func toAnyObject() -> NSDictionary {
        return [
            "name" : self.name ?? "Juanito",
            "email" : self.email ?? "example@gmail.com",
            "phone" : self.phone ?? 0000000000
        ]
    }
}
