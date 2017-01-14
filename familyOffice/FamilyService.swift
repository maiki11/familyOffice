//
//  FamilyService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 11/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase

class FamilyService {
    var ref: FIRDatabaseReference
    init() {
       
        ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com")
    }
    
    func  getFamiliesIds() ->  [String] {
        let user = (FIRAuth.auth()?.currentUser?.uid)!
        var keys : [String] = []
        let queue = DispatchQueue.global(qos: .userInitiated)
        let workItem = DispatchWorkItem(qos: .userInitiated, flags: .assignCurrentContext) {
            self.ref.child("/users/\(user)/families").observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                keys = value?.allKeys as! [String]
            }) { (error) in
                print(error.localizedDescription)
            }
        }
        queue.async(execute: workItem)
        return keys
    }
    func getFemilies(ids: [String]) -> [Family] {
        print(ids)
        var families : [Family] = []
        let refFamily = ref.child("/families/")
        for item in ids{
            refFamily.child(item).observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? NSDictionary
                let url = NSURL(string: value?["photoUrl"] as! String)
                let data = NSData(contentsOf:url! as URL)
                let model = Family(name: value!["name"] as! String, photoURL: url! , photo: UIImage(data: data as! Data)!)
                families.append(model)
                print(model)
            })
        }
        return families
    }
    
}
