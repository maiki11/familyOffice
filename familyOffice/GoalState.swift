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
    var GalleryState: GallleryState
}
enum Result<T> {
    case loading
    case failed
    case finished
    case Finished(T)
    case none
}

struct GoalState: StateType {
    var goals: [String:[Goal]] = [:]
    var status: Result<String>
}

struct FamilyState: StateType {
    var families: [Family] = []
    var status: Result<String>
}
