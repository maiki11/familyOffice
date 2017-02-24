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
    var uid = FIRAuth.auth()?.currentUser?.uid
    
    public static func Instance() -> AuthService {
        return instance
    }
    
    private static let instance : AuthService = AuthService()
    
    
    private init() {
    }
    //MARK: Shared Instance

    func login(email: String, password: String){
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if((error) != nil){
                print(error.debugDescription)
                NotificationCenter.default.post(name: LOGINERROR, object: nil)
            }else{
                ACTIVITYLOG_SERVICE.create(id: user!.uid, activity: "Se inicio sesión", photo: "", type: "sesion")
            }
        }
    }

    func userStatus(state: String) -> Void {
        REF_USERS.child(self.uid!).updateChildValues(["online": state])
    }

    func login(credential:FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential ) { (user, error) in
            print("Usuario autentificado con google")
            ACTIVITYLOG_SERVICE.create(id: user!.uid, activity: "Se inicio sesión", photo: "", type: "sesion")
        }
    }
    func logOut(){
        NOTIFICATION_SERVICE.deleteToken(token: NOTIFICATION_SERVICE.token, id: (USER_SERVICE.user?.id)!)
        try! FIRAuth.auth()!.signOut()
        REF_USERS.child("\((USER_SERVICE.user?.id)!)/families").removeAllObservers()
        UTILITY_SERVICE.clearObservers()
        NOTIFICATION_SERVICE.notifications.removeAll()
        ACTIVITYLOG_SERVICE.activityLog.removeAll()
        self.userStatus(state: "Offline")
        FAMILY_SERVICE.families.removeAll()
        USER_SERVICE.clearData()
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
                        ACTIVITYLOG_SERVICE.create(id: user.uid, activity: "Se creo la cuenta", photo: downloadURL, type: "sesion")
                        //self.userStatus(state: "Online")
                    }

                }
            }
        }
    }

    func isAuth(view: UIViewController, name: String)  {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            self.uid = user?.uid
            if (user != nil) {
                REF_USERS.child((user!.uid)).observeSingleEvent(of: .value, with: { (snapshot) in
                    // Get user value
                    if !snapshot.exists() {
                        self.createAccount(user: user as AnyObject)
                    }else{
                        USER_SERVICE.user = User(snapshot: snapshot)
                        USER_SERVICE.addUser(user: User(snapshot: snapshot))
                        NOTIFICATION_SERVICE.saveToken()
                        FAMILY_SERVICE.getFamilies()
                        //self.userStatus(state: "Online")
                        REF_USERS.child((user!.uid)).removeAllObservers()
                        UTILITY_SERVICE.gotoView(view: name, context: view)
                    }
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            }
        }
    }


}
