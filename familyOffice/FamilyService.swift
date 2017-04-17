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
            NotificationCenter.default.post(name: Constants.NotificationCenter.FAMILYADDED_NOTIFICATION, object: family)
            ToastService.getTopViewControllerAndShowToast(text: "Fam. agregada: \(family.name!)")
        }else{
            if let index = self.families.index(where: {$0.id == family.id}){
                self.families[index] = family
                ToastService.getTopViewControllerAndShowToast(text: "Familia actualizada: \(family.name!)")
                NotificationCenter.default.post(name: Constants.NotificationCenter.FAMILYUPDATED_NOTIFICATION, object: index)
            }
        }
        
    }
    
    func removed(snapshot: FIRDataSnapshot) -> Void {
        let key : String = snapshot.key
        //Actualizo la información de familias al usuario logeado
        if let index = Constants.Services.USER_SERVICE.users.index(where: {$0.id == FIRAuth.auth()?.currentUser?.uid})  {
            let filter =  Constants.Services.USER_SERVICE.users[index].families?.filter({$0.key as? String != key})
            var families : [String: Bool] = [:]
            for result in filter! {
                families[result.key as! String] = (result.value as! Bool)
            }
            Constants.Services.USER_SERVICE.users[index].families = families as NSDictionary
        }
        //Elimino la familia localmente
        if let index = self.families.index(where: {$0.id == key}){
            let family = self.families[index]
            self.families.remove(at: index)
            verifyFamilyActive(family: family)
            ToastService.getTopViewControllerAndShowToast(text: "Familia eliminada: \(family.name!)")
            NotificationCenter.default.post(name: Constants.NotificationCenter.FAMILYREMOVED_NOTIFICATION, object: index)
        }
    }
    
    func updated(snapshot: FIRDataSnapshot, id: Any) {
        if let index = Constants.Services.FAMILY_SERVICE.families.index(where: { $0.id == id as! String }){
            //let familyMirror = type(of: Mirror(reflecting: self.families[index] ).children.first(where: {$0.label == snapshot.key})?.value)
            self.families[index].update(snapshot: snapshot)
            NotificationCenter.default.post(name: Constants.NotificationCenter.FAMILYUPDATED_NOTIFICATION, object: index)
        }
    }
    
    func delete(family : Family) {
        for item in (family.members?.allKeys)! {
            Constants.FirDatabase.REF_USERS.child(item as! String).child("families/\((family.id)!)").removeValue()
        }
        Constants.FirStorage.STORAGEREF.child("families/\((family.id)!)/images/\((family.imageProfilePath)!)").delete(completion: { (error) -> Void in
            if (error != nil){
                print(error.debugDescription)
            }
        })
        Constants.FirDatabase.REF_FAMILIES.child(family.id!).removeValue()
        Constants.Services.ACTIVITYLOG_SERVICE.create(id: (Constants.Services.USER_SERVICE.users[0].id)!, activity: "Se elimino la familia \((family.name)!)", photo: (family.photoURL)!, type: "deleteFamily")
    }
    
    func createFamily(key: String, image: UIImage, name: String, users: [User], view: UIViewController){
        let membersDict : [String: Bool] = {
            var dic: [String:Bool] = [:]
            for user in users {
                dic[user.id] = true
            }
            return dic
        }()
        
        
        let imageName = NSUUID().uuidString
        if let uploadData = UIImagePNGRepresentation(image){
            _ = Constants.FirStorage.STORAGEREF.child("families/\(name)\(key)").child("images/\(imageName).png").put(uploadData, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error.debugDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    if let downloadURL = metadata?.downloadURL()?.absoluteURL {
                        StorageService.Instance().save(url: downloadURL.absoluteString, data: uploadData)
                        let family = Family(name:   name, photoURL: downloadURL.absoluteString, members: membersDict as NSDictionary, admin: (FIRAuth.auth()?.currentUser?.uid)! , id: name+key, imageProfilePath: metadata?.name)
                        Constants.Services.REQUEST_SERVICE.insert(value: family.toDictionary() as! NSDictionary, ref: "families/\((family.id)!)")
                        // REF_FAMILIES.child(family.id).setValue(family.toDictionary())
                        Constants.FirDatabase.REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).child("families").updateChildValues([family.id : true])
                        //Set family for app
                        self.selectFamily(family: family)
                        
                        Constants.Services.ACTIVITYLOG_SERVICE.create(id: (Constants.Services.USER_SERVICE.users[0].id)!,
                                                                      activity: "Se creo la familia  \((family.name)!)", photo: downloadURL.absoluteString, type: "addFamily")
                        //Go to Home
                        Utility.Instance().gotoView(view: "mainView", context: view.self)
                    }
                    
                }
            }
        }
    }
    
    func exitFamily(family: Family, uid:String) -> Void {
        Constants.FirDatabase.REF_USERS.child("/\(uid)/families/\((family.id)!)").removeValue()
        Constants.FirDatabase.REF_FAMILIES.child("/\((family.id)!)/members/\(uid)").removeValue()
        if(family.admin == Constants.Services.USER_SERVICE.users[0].id){
            self.addAdmin(index: self.families.index(where: {$0.id == family.id})!, uid: nil)
        }
    }
    
    func addAdmin(index: Int, uid: String?) -> Void {
        if(uid != nil){
            self.families[index].admin = uid
        }else{
            if (self.families[index].members?.count)! > 1 {
                for item in (self.families[index].members?.allKeys)! as! [String] {
                    if(Constants.Services.USER_SERVICE.users[0].id != item){
                        self.families[index].admin = item
                        Constants.FirDatabase.REF_FAMILIES.child(self.families[index].id).updateChildValues(["admin": item])
                        break
                    }
                }
            }else{
                delete(family: self.families[index])
            }
        }
    }
    
    func verifyFamilyActive(family: Family) -> Void {
        if(family.id == Constants.Services.USER_SERVICE.users[0].familyActive){
            if(self.families.count > 0){
                self.selectFamily(family: self.families[0])
            }else{
                NotificationCenter.default.post(name: Constants.NotificationCenter.NOFAMILIES_NOTIFICATION, object: nil)
            }
        }
    }
    
    func selectFamily(family: Family) -> Void {
        Constants.FirDatabase.REF_USERS.child((FIRAuth.auth()?.currentUser?.uid)!).updateChildValues(["familyActive" : family.id])
        Constants.Services.USER_SERVICE.setFamily(family: family)
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
            Constants.FirDatabase.REF_FAMILIES.child("\(familyID)/members").updateChildValues([memberID: true])
            Constants.FirDatabase.REF_USERS.child("\(memberID)/families").updateChildValues([familyID:true])
            NotificationCenter.default.post(name: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: [memberID:"added"])
        }
    }
    func addMember(uid: String, fid: String) -> Void {
      
        if let index = self.families.index(where: {$0.id == fid}) {
            var memberDict : [String:Bool]  = self.families[index].members as! [String : Bool]
            memberDict[uid] = true
            self.families[index].members = memberDict as NSDictionary?
            Constants.FirDatabase.REF_FAMILIES.child("\(fid)/members").updateChildValues([uid : true])
            Constants.FirDatabase.REF_USERS.child("\(uid)/families").updateChildValues([fid:true])
            Constants.Services.NOTIFICATION_SERVICE.send(title: "Agregado a: ", message: self.families[index].name!, to: uid)
            Constants.Services.NOTIFICATION_SERVICE.saveNotification(id: uid, title: "Agregado a: \(self.families[index].name!)", photo: self.families[index].photoURL!)
            ToastService.getTopViewControllerAndShowToast(text: "Miembro \((Constants.Services.USER_SERVICE.users.first(where: {$0.id == uid})?.name).unsafelyUnwrapped) Agregado")
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
            if (self.families[index].members?[Constants.Services.USER_SERVICE.users[0].id] == nil ){
                self.families.remove(at: index)
            }
            Constants.FirDatabase.REF_USERS.child("\((memberID))/families/\((familyID))").removeValue()
            Constants.FirDatabase.REF_FAMILIES.child("\(familyID)/members/\(memberID)").removeValue()
            NotificationCenter.default.post(name: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: [memberID : "removed"])
        }
    }
}
