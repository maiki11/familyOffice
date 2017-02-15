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
    
    
    private init(){
    }
    public static func Instance() -> NotificationService {
        return instance
    }
    
    private static let instance : NotificationService = NotificationService()
    
    func saveToken() -> Void {
        if(USER_SERVICE.user  != nil){
            if token == "", let refreshedToken = FIRInstanceID.instanceID().token() {
                print("InstanceID token: \(refreshedToken)")
                NOTIFICATION_SERVICE.token = refreshedToken
            }
            REF_USERS.child("\((USER_SERVICE.user?.id)!)/\(User.kUserTokensFCMeKey)").updateChildValues([self.token: true])
        }
    }
    
    func sendNotification(title: String, message: String, to: String){
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
    
}
