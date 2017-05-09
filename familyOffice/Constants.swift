//
//  Constants.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 24/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase


struct Constants {
    struct FirDatabase {
        static let REF = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
        static let REF_FAMILIES = REF.child("families")
        static let REF_USERS = REF.child("users")
        static let REF_ACTIVITY = REF.child("activityLog")
        static let REF_NOTIFICATION = REF.child("notifications")

    }
    
    struct FirStorage {
        static let STORAGEREF = FIRStorage.storage().reference(forURL: "gs://familyoffice-6017a.appspot.com")
    }
    
    struct Services {
        static let ACTIVITYLOG_SERVICE = ActivityLogService.Instance()
        static let UTILITY_SERVICE = Utility.Instance()
        static let AUTH_SERVICE = AuthService.Instance()
        static let ANIMATIONS = Animations.instance
        static let STORAGE_SERVICE = StorageService.Instance()
        static let FAMILY_SERVICE = FamilyService.Instance()
        static let USER_SERVICE = UserService.Instance()
        static let NOTIFICATION_SERVICE = NotificationService.Instance()
        static let ALERT_SERVICE = AlertService.Instance()
        static let REF_SERVICE = RefHandle.Instance()
       // static let REQUEST_SERVICE = RequestService.Instance()
        static let EVENT_SERVICE = EventService.Instance()
    }
    
    struct NotificationCenter {
        static let USER_NOTIFICATION = Notification.Name("UserNotification")
        static let NOFAMILIES_NOTIFICATION = Notification.Name("NoFamiliesNotification")
        static let LOGINERROR = Notification.Name("LoginNotification")
        static let USERS_NOTIFICATION = Notification.Name("UserNotification")
        static let FAMILYUPDATED_NOTIFICATION = Notification.Name("FamilyUpdatedNotification")
        static let FAMILYADDED_NOTIFICATION = Notification.Name("FamilyAddedNotification")
        static let FAMILYREMOVED_NOTIFICATION = Notification.Name("FamilyRemovedNotification")
        static let USERUPDATED_NOTIFICATION = Notification.Name("UserUpdatedNotification")
        static let SUCCESS_NOTIFICATION  = Notification.Name("SuccessNotification")
        static let ERROR_NOTIFICATION  = Notification.Name("ErrorNotification")
        static let BACKGROUND_NOTIFICATION = Notification.Name("BackgroundNotification")
    }

    struct ServerApi {
        static let SERVERKEY =  "AIzaSyAkiqHhHKI0xcXrYF9eq-D6PzhUl-mPOls"
        static let NOTIFICATION_URL = "https://fcm.googleapis.com/fcm/send"
    }
}

let modelName = UIDevice.current.modelName
//Notification Center

//Firebase References

//let REF = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
//let REF_FAMILIES = REF.child("families")
//let REF_USERS = REF.child("users")
//let REF_ACTIVITY = REF.child("activityLog")
//let REF_NOTIFICATION = REF.child("notifications")


//Storage Reference


//Service


//Styles
let STYLES = Styles.Instance()

//Others


