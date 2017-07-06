//
//  AppReducer.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import ReSwift
struct AppReducer: Reducer {
    
    func handleAction(action: Action, state: AppState?) -> AppState {
        
        return AppState(
            GoalsState: GoalReducer().handleAction(action: action, state: state!.GoalsState),
            FamilyState: FamilyReducer().handleAction(action: action, state: state?.FamilyState)
        )
    }
    
}
