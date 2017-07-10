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
    public var sections : [SectionNotification] = []
    private init(){
    }
    public static func Instance() -> NotificationService {
        return instance
    }
    
    private static let instance : NotificationService = NotificationService()
    
    func saveToken() -> Void {
        if let refreshedToken = FIRInstanceID.instanceID().token() {
            print("InstanceID token: \(refreshedToken)")
            service.NOTIFICATION_SERVICE.token = refreshedToken
        }
        if store.state.UserState.user != nil {
            Constants.FirDatabase.REF_USERS.child("\((store.state.UserState.user?.id)!)/\(User.kUserTokensFCMeKey)").updateChildValues([self.token: true])
        }
    }
    func verifyDuplicateCode() -> Void {
        
    }
    func send(title: String, message: String, to: String) -> Void {
        if let user = service.USER_SERVICE.users.first(where: {$0.id == to}) {
            for token in (user.tokens?.allKeys)! {
                sendNotification(title: title, message: message, to: token as! String)
            }
        }
    }
    func sendNotification(title: String, message: String, to: String){
        let headers = [
            "Content-Type" : "application/json",
            "Authorization": "key=\(Constants.ServerApi.SERVERKEY)"
        ]
        let _notification: Parameters? =
            [
                "to": "\(to)",
                "notification": [
                    "body": message,
                    "title": title
                ]
        ]
        
        Alamofire.request(Constants.ServerApi.NOTIFICATION_URL, method: .post, parameters: _notification, encoding: JSONEncoding.default, headers: headers).responseJSON(completionHandler: {
            (res) in
            print(res)
            
        })
    }
    
    func add(notification: NotificationModel) -> Void {
        
        if !self.sections.contains(where: {$0.date == Date(timeIntervalSince1970: abs(notification.timestamp)).monthYearLabel}){
            sections.append(SectionNotification(date: Date(timeIntervalSince1970: abs(notification.timestamp)).monthYearLabel, record: [notification]))
        }else{
            if !self.sections.contains(where: {$0.record.contains(where: {$0.id == notification.id}) }) {                sections[sections.count-1].record.append(notification)
            }
        }
        NotificationCenter.default.post(name: notCenter.SUCCESS_NOTIFICATION, object: notification)
    }
    
    func saveNotification(id: String, title: String, photo:String) -> Void {
        let key = Constants.FirDatabase.REF_NOTIFICATION.child(id).childByAutoId().key
        let notification = NotificationModel(id: key, title: title, timestamp: Utility.Instance().getDate(), photoURL: photo)
        Constants.FirDatabase.REF_NOTIFICATION.child("\(id)/\(key)").setValue(notification.toDictionary())
        
    }
    func seenNotification(index: Int) -> Void {
        
        self.notifications[index].seen = true
        Constants.FirDatabase.REF_NOTIFICATION.child(service.USER_SERVICE.users[0].id).child(self.notifications[index].id!).updateChildValues(self.notifications[index].toDictionary() as! [AnyHashable : Any])
        
    }
    
    func deleteToken(token: String, id: String) -> Void {
        Constants.FirDatabase.REF_USERS.child("\(id)/\(User.kUserTokensFCMeKey)/\(token)").removeValue()
    }
    
}
