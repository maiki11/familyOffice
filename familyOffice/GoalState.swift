//
//  GoalState.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter

struct AppState: StateType {
    var GoalsState : GoalState
    var FamilyState: FamilyState
}
enum Result {
    case loading
    case failed
    case finished
    case none
}

struct GoalState: StateType {
    var goals: [String:[Goal]] = [:]
    var status: Result
}

struct FamilyState: StateType {
    var families: [Family] = []
    var status: Result
}
