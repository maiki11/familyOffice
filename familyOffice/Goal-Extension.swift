//
//  Goal-Extension.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//
import UIKit
extension GoalBindable {
    
    var titleLbl: UILabel! {
        return nil
    }
    var dateCreatedLbl: UILabel! {
        return nil
    }
    var endDateDP: UIDatePicker! {
        return nil
    }
    var endDateLbl: UILabel! {
        return nil
    }
    var photo: UIImageView! {
        return nil
    }
    var typeicon : UIImageView! {
        return nil
    }
    var creatorLbl: UILabel! {
        return nil
    }
    var noteLbl: UILabel! {
        return nil
    }
    var titleTxt: UITextField! {
        return nil
    }
    var doneSwitch: UISwitch! {
        return nil
    }
    
    func bind(goal: Goal) {
        self.goal = goal
        bind()
    }
    
    func bind() {
        
        guard let goal = self.goal else {
            return
        }
        
        if let titleLbl = self.titleLbl {
            titleLbl.text = goal.title
        }
    
        if let titleTxt = self.titleTxt {
            titleTxt.text = goal.title
        }
        
        if let endDateDP  = self.endDateDP {
            endDateDP.date = Date(string: goal.endDate, formatter: .InternationalFormat)!
        }

        if let endDateLbl  = self.endDateLbl {
            endDateLbl.text = "  " + goal.endDate != "" ? Date(string: goal.endDate, formatter: .InternationalFormat)!.string(with: .MonthdayAndYear) : "Sin fecha"
        }

        if let dateCreatedLbl = self.dateCreatedLbl {
            dateCreatedLbl.text = String(goal.dateCreated)
        }
        if let photo = self.photo, !goal.photo.isEmpty {
            photo.loadImage(urlString: goal.photo)
        }
        
        if let creatorLbl = self.creatorLbl {
            creatorLbl.text =  goal.creator
        }
        if let noteLbl = self.noteLbl {
            noteLbl.text = goal.note
        }
        
        if let doneSwitch = self.doneSwitch {
            if goal.type == 0 {
                doneSwitch.isOn = goal.done
            }else{
                doneSwitch.isOn = goal.members[(store.state.UserState.user?.id!)!]!
            }
        }
        
        
        if let typeicon = self.typeicon {
            var ximage :UIImage!
            if let value = GoalCategory(rawValue: goal.category){
                switch value {
                case .sport:
                    ximage = #imageLiteral(resourceName: "sport")
                    break
                case .religion:
                    ximage = #imageLiteral(resourceName: "religion")
                    break
                case .school:
                    ximage = #imageLiteral(resourceName: "school")
                    break
                case .business:
                    ximage = #imageLiteral(resourceName: "business-1")
                    break
                case .eat:
                    ximage = #imageLiteral(resourceName: "eat")
                    break
                case .health:
                    ximage = #imageLiteral(resourceName: "health-1")
                    break
                }
                if ximage != nil {
                    typeicon.image = ximage
                }

            }
            
            

        }
        
    }
    
}
