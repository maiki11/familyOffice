//
//  AppState.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 09/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter
struct AppState: StateType, HasNavigationState {
    var GoalsState : GoalState
    var FamilyState: FamilyState
    var navigationState: NavigationState
    var UserState: UserState
}
enum Result {
    case loading
    case failed
    case finished
    case none
}
