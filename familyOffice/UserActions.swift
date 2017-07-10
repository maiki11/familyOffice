//
//  UserActions.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 09/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRecorder

let userActionTypeMap: TypeMap = [InsertGoalAction.type: InsertGoalAction.self,
                                  UpdateGoalAction.type: UpdateGoalAction.self]

struct GetUserAction: StandardActionConvertible {
    static let type = "USER_ACTION_GET"
    var refUser: String!
    init(uid: String) {
        self.refUser = uid
    }
    init(_ standardAction: StandardAction) {
    }
    
    func toStandardAction() -> StandardAction {
        return StandardAction(type: InsertGoalAction.type, payload: [:], isTypedAction: true)
    }
}

