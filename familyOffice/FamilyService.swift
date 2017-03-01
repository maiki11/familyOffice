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
                for item in value?.allKeys as! [String] {
                    REF_FAMILIES.child(item).observeSingleEvent(of: .value, with: { (snapshot) in
                        if(snapshot.exists()){
                            let family = Family(snapshot: snapshot)
                            if !self.families.contains(where: { $0.id == family.id }) {
                                self.families.append(family)
                            }
                            if(USER_SERVICE.user?.familyActive == item || USER_SERVICE.user?.familyActive == ""){
                                self.selectFamily(family: family)
                                NotificationCenter.default.post(name: USER_NOTIFICATION, object: nil)
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
    
    func getFamilies(key: String) -> Void {
        REF_FAMILIES.child(key).observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            if(snapshot.exists()){
                let family = Family(snapshot: snapshot)
                if let index = self.families.index(where: { $0.id == family.id }) {
                    self.families[index] = family
                    NotificationCenter.default.post(name: FAMILYUPDATED_NOTIFICATION, object: index)
                }else{
                    self.families.append(family)
                    NotificationCenter.default.post(name: FAMILYADDED_NOTIFICATION, object: nil)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func delete(family : Family) {
        for item in (family.members?.allKeys)! {
            REF_USERS.child(item as! String).child("families/\((family.id)!)").removeValue()
        }
        
        
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
            _ = STORAGEREF.child("families/\(name)\(key)").child("images/\(imageName).png").put(uploadData, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error.debugDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    if let downloadURL = metadata?.downloadURL()?.absoluteURL {
                        StorageService.Instance().save(url: downloadURL.absoluteString, data: uploadData)
                        let family = Family(name:   name, photoURL: downloadURL as NSURL, members:  [(FIRAuth.auth()?.currentUser?.uid)! : true], admin: (FIRAuth.auth()?.currentUser?.uid)! , id: name+key, imageProfilePath: metadata?.name)
                        REF_FAMILIES.child(family.id).setValue(family.toDictionary())
                        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("families").updateChildValues([ family.id: true])
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
        if let index = self.families.index(where: {$0.id == family.id}) {
            var memberDict : [String:Bool]  = self.families[index].members as! [String : Bool]
            for member in members {
                memberDict[member.id] = true
                REF_USERS.child("\((member.id)!)/families").updateChildValues([family.id : true])
                for token in (member.tokens?.allKeys)! {
                    NOTIFICATION_SERVICE.sendNotification(title: "Se te agrego a la familia: ", message: "\((family.name)!)", to: token as! String, user: member)
                }
                NOTIFICATION_SERVICE.saveNotification(id: member.id, title: "Se te agrego a la familia: \((family.name)!)", photo: (USER_SERVICE.user?.photoURL)!)
            }
            self.families[index].members = memberDict as NSDictionary?
            REF_FAMILIES.child("\((family.id)!)/members").setValue(memberDict)
        }
    }
    
    
    func removeMember(member: User, family:Family) -> Void {
        REF_FAMILIES.child("\((family.id)!)/members/\((member.id)!)").removeValue()
        REF_USERS.child("\((member.id)!)/families/\((family.id)!)").removeValue()
        
        if let index = families.index(where: {$0.id == family.id})  {
            let filter = self.families[index].members?.filter({$0.key as? String != member.id})
            var members : [String: Bool] = [:]
            for result in filter! {
                members[result.key as! String] = (result.value as! Bool)
            }
            self.families[index].members = members as NSDictionary
        }
    }
    
    func exitFamily(family: Family, uid:String) -> Void {
        REF_USERS.child("/\(uid)/families/\((family.id)!)").removeValue()
        REF_FAMILIES.child("/\((family.id)!)/members/\(uid)").removeValue()
        if(family.admin == USER_SERVICE.user?.id){
            self.addAdmin(index: self.families.index(where: {$0.id == family.id})!, uid: nil)
        }
        
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
    func removeFamily(family: Family) -> Void {
        if let index = self.families.index(where: {$0.id == family.id}){
            self.families.remove(at: index)
            verifyFamilyActive(family: family)
            NotificationCenter.default.post(name: FAMILYREMOVED_NOTIFICATION, object: index)
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
    func selectFamily(family: Family) -> Void {
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["familyActive" : family.id])
        USER_SERVICE.setFamily(family: family)
    }
    
    
}
