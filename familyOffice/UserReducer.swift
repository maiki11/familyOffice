//
//  UserReducer.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 09/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import ReSwift

struct UserReducer: Reducer {
    func handleAction(action: Action, state: UserState?) -> UserState {
        var state = state ?? UserState(users: [], user: nil, status: .none)
        
        switch action {
        case let action as GetUserAction:
            getUser(action.uid)
            state.status = .loading
        default:
            break
        }
        return state
    }
    
    func getUser(_ uid: String) -> Void {
        service.USER_SVC.valueSingleton(ref: ref_users(uid: uid))
    }
}
