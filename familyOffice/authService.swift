//
//  AuthService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 03/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import FirebaseAuth
class AuthService {
    static let authService = AuthService()
    private init() { }
    
    //MARK: Shared Instance
    
    public func login(email: String, password: String)->Bool{
        var errorLogin : Bool = false
        FIRAuth.auth()?.signIn(withEmail: email, password: password) { (user, error) in
            if((error) != nil){
                errorLogin = true
                print(error.debugDescription)
            }
        }
        return errorLogin
    }   
}
