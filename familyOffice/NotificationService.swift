//
//  NotificationService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 13/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Alamofire
import Firebase

class NotificationService {
    var token = ""
    public var notifications : [NotificationModel] = []
    private init(){
    }
    public static func Instance() -> NotificationService {
        return instance
    }
    
    private static let instance : NotificationService = NotificationService()
    
    func saveToken() -> Void {
        if(USER_SERVICE.user  != nil){
            if let refreshedToken = FIRInstanceID.instanceID().token() {
                print("InstanceID token: \(refreshedToken)")
                NOTIFICATION_SERVICE.token = refreshedToken
            }
            REF_USERS.child("\((USER_SERVICE.user?.id)!)/\(User.kUserTokensFCMeKey)").updateChildValues([self.token: true])
        }
    }
    func verifyDuplicateCode() -> Void {
        
    }
    
    func sendNotification(title: String, message: String, to: String, user: User){
       let headers = [
            "Content-Type" : "application/json",
            "Authorization": "key=\(SERVERKEY)"
        ]
        let _notification: Parameters? =
        [
            "to": "\(to)",
            "notification": [
                "body": message,
                "title": title
            ]
        ]
        
        Alamofire.request(NOTIFICATION_URL, method: .post, parameters: _notification, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {
            (res) in
            print(res)
            
        })
    }

    func add(notification: NotificationModel) -> Void {
        if !self.notifications.contains(where: {$0.id == notification.id}){
            self.notifications.append(notification)
            NotificationCenter.default.post(name: SUCCESS_NOTIFICATION, object: notification)
        }
    }

    func saveNotification(id: String, title: String, photo:String) -> Void {
        let key = REF_NOTIFICATION.child(id).childByAutoId().key
        let notification = NotificationModel(id: key, title: title, timestamp: Utility.Instance().getDate(), photoURL: photo)
        REF_NOTIFICATION.child("\(id)/\(key)").setValue(notification.toDictionary())
        notifications.append(notification)
    }
    
    func deleteToken(token: String, id: String) -> Void {
        REF_USERS.child("\(id)/\(User.kUserTokensFCMeKey)/\(token)").removeValue()
    }
    
}
