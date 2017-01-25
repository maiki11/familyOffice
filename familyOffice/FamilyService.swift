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
    
    public static let instance = FamilyService()
    var ref: FIRDatabaseReference! = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
    var storageRef = FIRStorage.storage().reference(forURL: "gs://familyoffice-6017a.appspot.com")
    var families: [Family] = []
    
    private init() {
    }
    func getFamilies(completionHandler:@escaping (_ familyArray: [Family]?)-> Void) {
        
        self.ref.child("/users/\((FIRAuth.auth()?.currentUser?.uid)!)/families").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            if(snapshot.exists()){
                let refFamily = self.ref.child("families/")
                self.families = []
                DispatchQueue.main.async() {
                    for item in value?.allKeys as! [String] {
                        DispatchQueue.main.async() {
                            refFamily.child(item).observeSingleEvent(of: .value, with: { (snapshot) in
                                let value = snapshot.value as? NSDictionary
                                if(snapshot.exists()){
                                    let url = NSURL(string: value?["photoUrl"] as! String)
                                    let data = NSData(contentsOf:url! as URL)
                                    let model = Family(name: value!["name"] as! String, photoURL: url! , photo: UIImage(data: data as! Data)!, active: false)
                                    model.id = item
                                    if let admin = value?["admin"] {
                                        model.admin = admin as! String
                                    }
                                    refFamily.child(item).child("members").observeSingleEvent(of: .value, with: { (snapshot)  in
                                        model.totalMembers = snapshot.childrenCount
                                        self.families.append(model)
                                        if(User.Instance().userDefaults.string(forKey: "familyId") == model.id){
                                            self.selectFamily(family: model)
                                        }
                                    })
                                }else{
                                     NotificationCenter.default.post(name: NOFAMILIES_NOTIFICATION, object: nil)
                                }
                               
                            })
                        }
                    }
                    
                }
                if self.families.isEmpty {
                    completionHandler(nil)
                }else {
                    completionHandler(self.families)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
        
        
    }
    
    func delete(id : String) {
        self.ref.child("/families/\((id))/members").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            let refFamily = self.ref.child("users")
            for item in value?.allKeys as! [String] {
                refFamily.child(item).child("families/\(id)").removeValue()
            }
            self.ref.child("/families/\(id)").removeValue()
            Utility.Instance().clearObservers()
        }) { (error) in
            print(error.localizedDescription)
        }
    }
   
    func createFamily(key: String, image: UIImage, name: String, view: UIViewController){
        let imageName = NSUUID().uuidString
        
        if let uploadData = UIImagePNGRepresentation(image){
            
            _ = storageRef.child(key).child("images").child("\(imageName).png").put(uploadData, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error.debugDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        
                        let family = ["name": name as String,
                                      "photoUrl": downloadURL as Any,
                                      "members": [ (FIRAuth.auth()?.currentUser?.uid)! : true] as [String : Bool],
                                      "admin":  (FIRAuth.auth()?.currentUser?.uid)!]
                        
                        let model = Family()
                        model.id = key
                        model.name = name
                        model.photo = image
                        self.ref.child("families").child(key).setValue(family)
                        self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).child("families").setValue([ key: true])
                        //Set family for app
                        self.selectFamily(family: model)
                        //Go to Home
                        Utility.Instance().gotoView(view: "TabBarControllerView", context: view.self)
                    }
                    
                }
            }
        }
    }
    func selectFamily(family: Family) -> Void {
        self.ref.child("users/\((FIRAuth.auth()?.currentUser?.uid)!)").updateChildValues(["familyActive": family.id])
        let photo = UIImagePNGRepresentation(family.photo)
        User.Instance().setFamily(family: family, photoData: photo!)
        print(User.Instance().getData().family?.name ?? "Ninguno")
    }
    
}
