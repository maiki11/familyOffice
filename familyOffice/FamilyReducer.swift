//
//  FamilyReducer.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 04/07/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import ReSwift

struct FamilyReducer: Reducer {
    func handleAction(action: Action, state: FamilyState?) -> FamilyState {
        let state = state ?? FamilyState(families: [], status: .none)
        return state
    }
}
