//
//  FamilyService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 11/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit

class FamilyService {
    
    public static let instance = FamilyService()
    
    var families: [Family] = []
    
    private init() {
    }
    func getFamilies() {
        
        REF.child("/users/\((FIRAuth.auth()?.currentUser?.uid)!)/families").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if(snapshot.exists()){
                self.families = []
                for item in value?.allKeys as! [String] {
                    REF_FAMILIES.child(item).observeSingleEvent(of: .value, with: { (snapshot) in
                        if(snapshot.exists()){
                            let family = Family(snapshot: snapshot)
                            self.families.append(family)
                            if(family.id == item){
                                User.Instance().setFamily(family: family)
                                NotificationCenter.default.post(name: USER_NOTIFICATION, object: nil)
                            }
                        }else{
                            NotificationCenter.default.post(name: NOFAMILIES_NOTIFICATION, object: nil)
                        }
                        
                    })
                    
                }
            }else{
                NotificationCenter.default.post(name: NOFAMILIES_NOTIFICATION, object: nil)
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    func removeHandles() -> Void {
    }
    
    func delete(id : String) {
        REF_FAMILIES.child("\(id))/members").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let refFamily = REF.child("users")
            for item in value?.allKeys as! [String] {
                refFamily.child(item).child("families/\(id)").removeValue()
            }
            REF_FAMILIES.child(id).removeValue()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func createFamily(key: String, image: UIImage, name: String, view: UIViewController){
        let imageName = NSUUID().uuidString
        
        if let uploadData = UIImagePNGRepresentation(image){
            
            _ = STORAGEREF.child("families/\(key)").child("images").child("\(imageName).png").put(uploadData, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error.debugDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    if let downloadURL = metadata?.downloadURL()?.absoluteURL {
                        let family = Family(name: name, photoURL: downloadURL as NSURL, photo: uploadData, members:  [(FIRAuth.auth()?.currentUser?.uid)! : true], admin: (FIRAuth.auth()?.currentUser?.uid)! , id: key)
                        REF_FAMILIES.child(key).setValue(family.toDictionary())
                        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("families").updateChildValues([ key: true])
                        //Set family for app
                        self.selectFamily(family: family)
                        self.families.append(family)
                        //Go to Home
                        Utility.Instance().gotoView(view: "TabBarControllerView", context: view.self)
                    }
                    
                }
            }
        }
    }
    func selectFamily(family: Family) -> Void {
        print(family.id)
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["familyActive" : family.id])
        User.Instance().setFamily(family: family)
        print(User.Instance().getData().family?.name ?? "Ninguno")
        NotificationCenter.default.post(name: USER_NOTIFICATION, object: nil)
    }
    
}
