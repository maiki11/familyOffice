//
//  UserModel.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 05/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class UserService {
    public var user : User? = nil
    public var users: [User] = []
    private init(){
    }
    public static func Instance() -> UserService {
        return instance
    }
    
    static let instance : UserService = UserService()
   
    func setFamily(family: Family) -> Void {
        user?.family = family
        user?.familyActive = family.id
    }
    
    func getUser(uid: String, mainly: Bool) -> Void {
        REF.child("/users/\(uid)").observeSingleEvent(of: .value, with: { (snapshot) in
            if(snapshot.exists()){
                let user = User(snapshot: snapshot)
                if(mainly){
                    self.user = user
                }
                if(self.duplicate(id:user.id)){
                    self.users.append(User(snapshot: snapshot))
                    NotificationCenter.default.post(name: USERS_NOTIFICATION, object: nil)
                }
            }
        }) { (error) in
            print(error.localizedDescription)
        }
    }
 
    func searchUser(uid: String)->User?{
        for item in self.users {
            if(item.id == uid){
                return item
            }
        }
        return nil
    }
    
    func clearData() {
        self.user = nil
    }
    
    private func removeUser(user: User) -> Void {
        var cont = 0
        for item in self.users {
            if(item.id == user.id){
                self.users.remove(at: cont)
            }
            cont += 1
        }
    }
    func duplicate(id: String) -> Bool {
        var bool = true
        for item in self.users {
            if(item.id == id){
                bool = false
                break
            }
        }
        return bool
    }
}
