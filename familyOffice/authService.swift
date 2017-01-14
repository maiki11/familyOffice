//
//  AuthService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 03/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import UIKit

class AuthService {
   
    var storageRef: FIRStorageReference!
    
    public static let authService = AuthService()
    var ref: FIRDatabaseReference!
    private init() {
        
    }
    //MARK: Shared Instance
    
    func login(email: String, password: String){
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if((error) != nil){
                print(error.debugDescription)
            }
        }
        
    }
    
    func login(credential:FIRAuthCredential){
        self.ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
        FIRAuth.auth()?.signIn(with: credential ) { (user, error) in
            print("Usuario autentificado con google")
            self.ref.child("users").child((user!.uid)).observeSingleEvent(of: .value, with: { (snapshot) in
                // Get user value
                if !snapshot.exists() {
                     self.createAccount(user: user as AnyObject)
                }
            }) { (error) in
                print(error.localizedDescription)
            }
        }
    }
    func logOut(){
        try! FIRAuth.auth()!.signOut()
        User.Instance().clearData()
    }
    
    //Create account with federate entiies like Facebook Twitter Google  etc
    func createAccount(user: AnyObject)   {
        storageRef = FIRStorage.storage().reference(forURL: "gs://familyoffice-6017a.appspot.com")
        ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
        let imageName = NSUUID().uuidString
        let url = user.photoURL
        let data = NSData(contentsOf:url!! as URL)
        if let uploadData = UIImagePNGRepresentation(UIImage(data: data as! Data)!){
            
            let uploadTask = storageRef.child("users").child(user.uid).child("images").child("\(imageName).png").put(uploadData, metadata: nil) { metadata, error in
                if (error != nil) {
                    // Uh-oh, an error occurred!
                    print(error.debugDescription)
                } else {
                    // Metadata contains file metadata such as size, content-type, and download URL.
                    if let downloadURL = metadata?.downloadURL()?.absoluteString {
                        
                        let xuserModel = ["name" : user.displayName!,
                                          "photoUrl": downloadURL] as [String : Any]
                        self.ref.child("users").child(user.uid).setValue(xuserModel)
                    }
                    
                }
            }
        }
        
        
    }
    
    func isAuth(view: UIViewController, name: String)  {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if (user != nil) {
                AuthService.authService.setData()
                Utility.Instance().gotoView(view: name, context: view)
            }
        }
    }
    
    func setData()  {
        let ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/users/")
        let uid = (FIRAuth.auth()?.currentUser?.uid)!
        ref.child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? NSDictionary
            var url : NSURL
            var data : Any
            
            if ((value?["photoUrl"]) != nil) {
                url = (NSURL(string: (value?["photoUrl"] as? String)!) ?? nil)!
                data = NSData(contentsOf:url as URL)
            } else {
                data = UIImagePNGRepresentation(#imageLiteral(resourceName: "Profile"))! as NSData
            }
            
            let xuser = usermodel(name: self.exist(field: "name", dictionary: value!), phone: self.exist(field: "phone", dictionary: value!), photo: data as! NSData, families: [])
           
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
