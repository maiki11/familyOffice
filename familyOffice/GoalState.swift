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



struct GoalState: StateType {
    var goals: [String:[Goal]] = [:]
    var status: Result<Any> = .none
}

struct FamilyState: StateType {
    var families = [Family]()
    var status: Result<Any> = .none
}
