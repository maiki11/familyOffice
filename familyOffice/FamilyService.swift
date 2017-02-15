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
    private static let instance : FamilyService = FamilyService()
    var families: [Family] = []
    
    private init() {
    }
    
    public static func Instance() -> FamilyService {
        return instance
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
                            if(USER_SERVICE.user?.familyActive == item){
                                self.selectFamily(family: family)
                            }
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
    
    func delete(family : Family) {
        for item in (family.members?.allKeys)! {
            REF_USERS.child(item as! String).child("families/\((family.id)!)").removeValue()
        }
        self.removeFamily(family: family)
        STORAGEREF.child("families/\((family.id)!)/images/\((family.imageProfilePath)!)").delete(completion: { (error) -> Void in
            if (error != nil){
                print(error.debugDescription)
            }
          }
        )
        REF_FAMILIES.child(family.id!).removeValue()
        ACTIVITYLOG_SERVICE.create(id: (USER_SERVICE.user?.id)!, activity: "Se elimino la familia \((family.name)!)", photo: (family.photoURL?.absoluteString)!, type: "deleteFamily")
    }
    
    func createFamily(key: String, image: UIImage, name: String, view: UIViewController){
        let imageName = NSUUID().uuidString
        
        if let uploadData = UIImagePNGRepresentation(image){
            
            _ = STORAGEREF.child("families/\(key)").child("images/\(imageName).png").put(uploadData, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error.debugDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    if let downloadURL = metadata?.downloadURL()?.absoluteURL {
                        StorageService.Instance().save(url: downloadURL.absoluteString, data: uploadData)
                        let family = Family(name: name, photoURL: downloadURL as NSURL, members:  [(FIRAuth.auth()?.currentUser?.uid)! : true], admin: (FIRAuth.auth()?.currentUser?.uid)! , id: key, imageProfilePath: metadata?.name)
                        REF_FAMILIES.child(key).setValue(family.toDictionary())
                        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("families").updateChildValues([ key: true])
                        //Set family for app
                        self.selectFamily(family: family)
                        self.families.append(family)
                        ACTIVITYLOG_SERVICE.create(id: (USER_SERVICE.user?.id)!, activity: "Se creo la familia  \((family.name)!)", photo: downloadURL.absoluteString, type: "addFamily")
                        //Go to Home
                        Utility.Instance().gotoView(view: "TabBarControllerView", context: view.self)
                    }
                    
                }
            }
        }
    }
    func addMembers(members: [User], family: Family) -> Void {
        var index = 0
        for fam in families {
            
            if(fam.id == family.id){
                var memberDict : [String:Bool]  = self.families[index].members as! [String : Bool]
                for member in members {
                    memberDict[member.id] = true
                    REF_USERS.child("\((member.id)!)/families").updateChildValues([family.id : true])
                    for token in (member.tokens?.allKeys)! {
                         NOTIFICATION_SERVICE.sendNotification(title: "Familia Creada", message: "\((family.name)!)", to: token as! String)
                    }
                }
                self.families[index].members = memberDict as NSDictionary?
                REF_FAMILIES.child("\((family.id)!)/members").setValue(memberDict)
                break
            }
            index+=1
        }
    }
    func exitFamily(family: Family, uid:String) -> Void {
        print(REF_USERS.child("/\(uid)/families/\((family.id)!)").description())
        REF_USERS.child("/\(uid)/families/\((family.id)!)").removeValue()
        REF_FAMILIES.child("/\((family.id)!)/members/\(uid)").removeValue()
        if(family.admin == USER_SERVICE.user?.id){
            self.addAdmin(index: searchFamilyIndex(id: family.id)!, uid: nil)
        }
        removeFamily(family: family)
    }
    func addAdmin(index: Int, uid: String?) -> Void {
        if(uid != nil){
            self.families[index].admin = uid
        }else{
            if (self.families[index].members?.count)! > 1 {
                for item in (self.families[index].members?.allKeys)! as! [String] {
                    if(USER_SERVICE.user?.id != item){
                        self.families[index].admin = item
                        REF_FAMILIES.child(self.families[index].id).updateChildValues(["admin": item])
                    }
                }
            }else{
                delete(family: self.families[index])
            }
        }
    }
    func searchFamily(id: String) -> Family? {
        for item in self.families {
            if(item.id == id){
                return item
            }
        }
        return nil
    }
    private func removeFamily(family: Family) -> Void {
        var cont = 0
        for item in self.families {
            if(item.id == family.id){
                self.families.remove(at: cont)
                verifyFamilyActive(family: family)
            }
            cont += 1
        }
    }
    func verifyFamilyActive(family: Family) -> Void {
        if(family.id == USER_SERVICE.user?.familyActive){
            if(self.families.count > 0){
                self.selectFamily(family: self.families[0])
            }else{
                NotificationCenter.default.post(name: NOFAMILIES_NOTIFICATION, object: nil)
            }
        }
    }
    func searchFamilyIndex(id: String) -> Int? {
        var index = 0
        for item in self.families {
            if(item.id == id){
                return index
            }
            index+=1
        }
        return nil
    }
    func duplicate(id: String) -> Bool {
        var bool = true
        for item in self.families {
            if(item.id == id){
                bool = false
                break
            }
        }
        return bool
    }
    func selectFamily(family: Family) -> Void {
        print(family.id)
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["familyActive" : family.id])
        USER_SERVICE.setFamily(family: family)
        NotificationCenter.default.post(name: USER_NOTIFICATION, object: nil)
    }
    
}
