//
//  GoalReducer.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import ReSwift
import ReSwiftRouter
import Firebase

struct GoalReducer: Reducer {
    
    func handleAction(action: Action, state: GoalState?) -> GoalState {
        var state = state ?? GoalState(goals: [:], status: .none)
        switch action {
        case let action as InsertGoalAction:
            if action.goal == nil {
               return state
            }
            insertGoal(action.goal)
            state.status = .loading
        case let action as UpdateGoalAction:
            if action.goal == nil {
                return state
            }
            updateGoal(action.goal)
            state.status = .loading
            return state
        default: break
        }
        return state
    }
    
    func insertGoal(_ goal: Goal) -> Void {
        let id = getPath(type: goal.type)
        let path = "goals/\(id)/\(goal.id!)"
        service.GOAL_SERVICE.insert(path, value: goal.toDictionary(), callback: {ref in
            if ref is FIRDatabaseReference {
                store.state.GoalsState.goals[id]?.append(goal)
            }
        })
    }
    
    func updateGoal(_ goal: Goal) -> Void {
        let id = getPath(type: goal.type)
        let path = "goals/\(id)/\(goal.id!)"
        service.GOAL_SERVICE.update(path, value: goal.toDictionary() as! [AnyHashable : Any], callback: { ref in
            if ref is FIRDatabaseReference {
                if let index = store.state.GoalsState.goals[id]?.index(where: {$0.id == goal.id }){
                    store.state.GoalsState.goals[id]?[index] = goal
                    store.state.GoalsState.status = .finished
                }
                
            }
            
        })
    }
    
    func getPath(type: Int) -> String {
        if type == 0 {
            return service.USER_SERVICE.users[0].id!
        }else{
            return service.USER_SERVICE.users[0].familyActive!
        }
    }
}


