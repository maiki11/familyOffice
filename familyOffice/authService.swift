//
//  AuthService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 03/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
class AuthService {
    
    public static let authService = AuthService()
    private init() { }
    
    //MARK: Shared Instance
    
     func login(email: String, password: String)->Bool{
        var errorLogin : Bool = true
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if((error) != nil){
                errorLogin = true
                print(error.debugDescription)
            }else{
                errorLogin = false  
            }
        }
        return errorLogin
    }
    
    func login(credential:FIRAuthCredential){
        FIRAuth.auth()?.signIn(with: credential ) { (user, error) in
            print("Usuario autentificado con google")
            self.createAccount(user: user as AnyObject)
        }
    }
    func logOut(){
        try! FIRAuth.auth()!.signOut()
    }
    
    func createAccount(user: AnyObject)   {
        let ref = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
        let userModel = ["name" : user.displayName!]
        
        ref.child("users").child(user.uid).setValue(userModel)
    }
    
   
}
