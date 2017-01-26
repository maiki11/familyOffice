//
//  AuthService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 03/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import FirebaseAuth
import UIKit
class AuthService {

    
    public static let authService = AuthService()
    var uid = FIRAuth.auth()?.currentUser?.uid
    private init() {
    }
    //MARK: Shared Instance
    
    func login(email: String, password: String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if((error) != nil){
                print(error.debugDescription)
                NotificationCenter.default.post(name: LOGINERROR, object: nil)
            }
        }
    }
    
    func userStatus(state: String) -> Void {
        REF_USERS.child(self.uid!).updateChildValues(["online": state])
    }
    
    func login(credential:FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential ) { (user, error) in
            print("Usuario autentificado con google")
        }
    }
    func logOut(){
        try! FIRAuth.auth()!.signOut()
        User.Instance().clearData()
        self.userStatus(state: "Offline")
        FamilyService.instance.families = []
    }
    
    //Create account with federate entiies like Facebook Twitter Google  etc
    func createAccount(user: AnyObject)   {
        let imageName = NSUUID().uuidString
        let url = user.photoURL
        let data = NSData(contentsOf:url!! as URL)
        if let uploadData = UIImagePNGRepresentation(UIImage(data: data as! Data)!){
            STORAGEREF.child("users").child(user.uid).child("images").child("\(imageName).jpg").put(uploadData, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error.debugDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        
                        let xuserModel = ["name" : user.displayName!,
                                          "photoUrl": downloadURL] as [String : Any]
                        REF_USERS.child(user.uid).setValue(xuserModel)
                        self.setData()
                        self.userStatus(state: "Online")
                    }
                    
                }
            }
        }
    }
    
    func isAuth(view: UIViewController, name: String)  {
        var checkFamily = false;
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            self.uid = user?.uid
            if (user != nil) {
                
                NotificationCenter.default.addObserver(forName: NOFAMILIES_NOTIFICATION, object: nil, queue: nil){ notification in
                    Utility.Instance().gotoView(view: "RegisterFamilyView", context: view)
                    return
                }
                if(!checkFamily){
                    FamilyService.instance.getFamilies()
                    checkFamily = true
                }
                REF_USERS.child((user!.uid)).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    if !snapshot.exists() {
                        self.createAccount(user: user as AnyObject)
                    }else{
                        self.setData()
                        self.userStatus(state: "Online")
                        Utility.Instance().gotoView(view: name, context: view)
                    }
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func setData()  {
        print(REF)
        REF_USERS.child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var url : NSURL
            var data : Any
            if ((value?["photoUrl"]) != nil) {
                url = (NSURL(string: (value?["photoUrl"] as? String)!) ?? nil)!
                data = NSData(contentsOf:url as URL)!
            } else {
                data = UIImagePNGRepresentation(#imageLiteral(resourceName: "profile_default"))! as NSData
            }
            let xuser = usermodel(name: self.exist(field: "name", dictionary: value!), phone: self.exist(field: "phone", dictionary: value!), photo: data as! NSData, families: [], family: nil)
            User.Instance().userDefaults.set(self.exist(field: "familyActive", dictionary: value!), forKey: "familyId")
            User.Instance().fillData(user: xuser)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    
    func exist(field: String, dictionary:NSDictionary) -> String {
        if let value = dictionary[field] {
            return value as! String
        }else {
            return ""
        }
    }
    func existData(field: String, dictionary: NSDictionary) -> Data? {
        if let value = dictionary[field] {
            return (value as! Data)
        }else {
            return UIImagePNGRepresentation(#imageLiteral(resourceName: "Profile2") )
        }
    }
    func existArray(field: String, dictionary:NSDictionary) -> [Any] {
        if let value = dictionary[field] {
            return value as! Array<Any>
        }else {
            return []
        }
    }
    
    
}
