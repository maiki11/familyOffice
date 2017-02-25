//
//  Constants.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 24/01/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Firebase

//Notification Center
let USER_NOTIFICATION = Notification.Name("UserNotification")
let NOFAMILIES_NOTIFICATION = Notification.Name("NoFamiliesNotification")
let LOGINERROR = Notification.Name("LoginNotification")
let USERS_NOTIFICATION = Notification.Name("UserNotification")

let FAMILYUPDATED_NOTIFICATION = Notification.Name("FamilyUpdatedNotification")
let FAMILYADDED_NOTIFICATION = Notification.Name("FamilyAddedNotification")
let FAMILYREMOVED_NOTIFICATION = Notification.Name("FamilyRemovedNotification")

let SUCCESS_NOTIFICATION  = Notification.Name("SuccessNotification")
let ERROR_NOTIFICATION  = Notification.Name("ErrorNotification")

//Firebase References

let REF = FIRDatabase.database().reference(fromURL: "https://familyoffice-6017a.firebaseio.com/")
let REF_FAMILIES = REF.child("families")
let REF_USERS = REF.child("users")
let REF_ACTIVITY = REF.child("activityLog")
let REF_NOTIFICATION = REF.child("notifications")


//Storage Reference
let STORAGEREF = FIRStorage.storage().reference(forURL: "gs://familyoffice-6017a.appspot.com")

//Service
let ACTIVITYLOG_SERVICE = ActivityLogService.Instance()
let UTILITY_SERVICE = Utility.Instance()
let AUTH_SERVICE = AuthService.Instance()
let ANIMATIONS = Animations.instance
let STORAGE_SERVICE = StorageService.Instance()
let FAMILY_SERVICE = FamilyService.Instance()
let USER_SERVICE = UserService.Instance()
let NOTIFICATION_SERVICE = NotificationService.Instance()

//Others
let SERVERKEY =  "AIzaSyAkiqHhHKI0xcXrYF9eq-D6PzhUl-mPOls"
let NOTIFICATION_URL = "https://fcm.googleapis.com/fcm/send"
