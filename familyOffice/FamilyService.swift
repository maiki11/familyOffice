//
//  FamilyService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 11/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import UIKit

class FamilyService: repository {
    

    private static let instance : FamilyService = FamilyService()
    var families: [Family] = []
    
    private init() {
    }
    
    public static func Instance() -> FamilyService {
        return instance
    }
    
    func added(snapshot: FIRDataSnapshot) {
        let family : Family = Family(snapshot: snapshot)

        if !self.families.contains(where: { $0.id == family.id }) {
            self.families.append(family)
            NotificationCenter.default.post(name: FAMILYADDED_NOTIFICATION, object: family)
            ToastService.getTopViewControllerAndShowToast(text: "Fam. agregada: \(family.name!)")
        }else{
            if let index = self.families.index(where: {$0.id == family.id}){
                self.families[index] = family
                ToastService.getTopViewControllerAndShowToast(text: "Familia actualizada: \(family.name!)")
                NotificationCenter.default.post(name: FAMILYUPDATED_NOTIFICATION, object: index)
            }
        }
        
    }
    
    func removed(snapshot: FIRDataSnapshot) -> Void {
        let key : String = snapshot.key
        //Actualizo la información de familias al usuario logeado
        if let index = USER_SERVICE.users.index(where: {$0.id == FIRAuth.auth()?.currentUser?.uid})  {
            let filter =  USER_SERVICE.users[index].families?.filter({$0.key as? String != key})
            var families : [String: Bool] = [:]
            for result in filter! {
                families[result.key as! String] = (result.value as! Bool)
            }
            USER_SERVICE.users[index].families = families as NSDictionary
        }
        //Elimino la familia localmente
        if let index = self.families.index(where: {$0.id == key}){
            let family = self.families[index]
            self.families.remove(at: index)
            verifyFamilyActive(family: family)
            ToastService.getTopViewControllerAndShowToast(text: "Familia eliminada: \(family.name!)")
            NotificationCenter.default.post(name: FAMILYREMOVED_NOTIFICATION, object: index)
        }
    }
    
    func updated(snapshot: FIRDataSnapshot, id: Any) {
        if let index = FAMILY_SERVICE.families.index(where: { $0.id == id as! String }){
            //let familyMirror = type(of: Mirror(reflecting: self.families[index] ).children.first(where: {$0.label == snapshot.key})?.value)
            self.families[index].update(snapshot: snapshot)
            NotificationCenter.default.post(name: FAMILYUPDATED_NOTIFICATION, object: index)
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
        })
        REF_FAMILIES.child(family.id!).removeValue()
        ACTIVITYLOG_SERVICE.create(id: (USER_SERVICE.users[0].id)!, activity: "Se elimino la familia \((family.name)!)", photo: (family.photoURL)!, type: "deleteFamily")
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
                        let family = Family(name:   name, photoURL: downloadURL.absoluteString, members:  [(FIRAuth.auth()?.currentUser?.uid)! : true], admin: (FIRAuth.auth()?.currentUser?.uid)! , id: name+key, imageProfilePath: metadata?.name)
                        REQUEST_SERVICE.insert(value: family.toDictionary() as! NSDictionary, ref: "families/\((family.id)!)")
                        // REF_FAMILIES.child(family.id).setValue(family.toDictionary())
                        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("families").updateChildValues([family.id : true])
                        //Set family for app
                        self.selectFamily(family: family)
                        
                        ACTIVITYLOG_SERVICE.create(id: (USER_SERVICE.users[0].id)!, activity: "Se creo la familia  \((family.name)!)", photo: downloadURL.absoluteString, type: "addFamily")
                        //Go to Home
                        Utility.Instance().gotoView(view: "TabBarControllerView", context: view.self)
                    }
                    
                }
            }
        }
    }
    
    func exitFamily(family: Family, uid:String) -> Void {
        REF_USERS.child("/\(uid)/families/\((family.id)!)").removeValue()
        REF_FAMILIES.child("/\((family.id)!)/members/\(uid)").removeValue()
        if(family.admin == USER_SERVICE.users[0].id){
            self.addAdmin(index: self.families.index(where: {$0.id == family.id})!, uid: nil)
        }
    }
    
    func addAdmin(index: Int, uid: String?) -> Void {
        if(uid != nil){
            self.families[index].admin = uid
        }else{
            if (self.families[index].members?.count)! > 1 {
                for item in (self.families[index].members?.allKeys)! as! [String] {
                    if(USER_SERVICE.users[0].id != item){
                        self.families[index].admin = item
                        REF_FAMILIES.child(self.families[index].id).updateChildValues(["admin": item])
                        break
                    }
                }
            }else{
                delete(family: self.families[index])
            }
        }
    }
    
    func verifyFamilyActive(family: Family) -> Void {
        if(family.id == USER_SERVICE.users.first(where: {$0.id == (FIRAuth.auth()?.currentUser?.uid)!})?.familyActive){
            if(self.families.count > 0){
                self.selectFamily(family: self.families[0])
            }else{
                NotificationCenter.default.post(name: NOFAMILIES_NOTIFICATION, object: nil)
            }
        }else if USER_SERVICE.users[0].families?.count == FAMILY_SERVICE.families.count && FAMILY_SERVICE.families.count > 0 {
            selectFamily(family: family)
        }
    }
    
    func selectFamily(family: Family) -> Void {
        REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["familyActive" : family.id])
        USER_SERVICE.setFamily(family: family)
    }
}

extension FamilyService {
    //Added members
    func added(snapshot: FIRDataSnapshot, id: String) -> Void {
        let familyID = id
        let memberID = snapshot.key
        if let index = self.families.index(where: {$0.id == familyID}) {
            var memberDict : [String:Bool]  = self.families[index].members as! [String : Bool]
            memberDict[memberID] = true
            self.families[index].members = memberDict as NSDictionary?
            REF_FAMILIES.child("\(familyID)/members").updateChildValues([memberID: true])
            REF_USERS.child("\(memberID)/families").updateChildValues([familyID:true])
            NotificationCenter.default.post(name: SUCCESS_NOTIFICATION, object: [memberID:"added"])
        }
    }
    func addMember(uid: String, fid: String) -> Void {
      
        if let index = self.families.index(where: {$0.id == fid}) {
            var memberDict : [String:Bool]  = self.families[index].members as! [String : Bool]
            memberDict[uid] = true
            self.families[index].members = memberDict as NSDictionary?
            REF_FAMILIES.child("\(fid)/members").updateChildValues([uid : true])
            REF_USERS.child("\(uid)/families").updateChildValues([fid:true])
            NOTIFICATION_SERVICE.send(title: "Agregado a: ", message: self.families[index].name!, to: uid)
            NOTIFICATION_SERVICE.saveNotification(id: USER_SERVICE.users[0].id, title: "Agregado a: \(self.families[index].name!)", photo: self.families[index].photoURL!)
            ToastService.getTopViewControllerAndShowToast(text: "Miembro \((USER_SERVICE.users.first(where: {$0.id == uid})?.name).unsafelyUnwrapped) Agregado")
            //NotificationCenter.default.post(name: SUCCESS_NOTIFICATION, object: [uid:"added"])
        }
    }
    //Remove members
    func remove(snapshot: Any, id: Any) -> Void {
        let familyID = id as! String
        let memberID = snapshot as! String
        if let index = self.families.index(where: {$0.id == familyID})  {
            let filter = self.families[index].members?.filter({$0.key as? String != memberID})
            var members : [String: Bool] = [:]
            for result in filter! {
                members[result.key as! String] = (result.value as! Bool)
            }
            self.families[index].members = members as NSDictionary
            if (self.families[index].members?[USER_SERVICE.users[0].id] == nil ){
                self.families.remove(at: index)
            }
            REF_USERS.child("\((memberID))/families/\((familyID))").removeValue()
            REF_FAMILIES.child("\(familyID)/members/\(memberID)").removeValue()
            NotificationCenter.default.post(name: SUCCESS_NOTIFICATION, object: [memberID : "removed"])
        }
    }
}
