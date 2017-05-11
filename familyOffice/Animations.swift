 //
//  animations.swift
//  familyOffice
//
//  Created by miguel reina on 27/01/17.
//  Copyright © 2017 Miguel Reina y Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseDatabase
import FirebaseAuth
private var activityIndicatior:UIActivityIndicatorView = UIActivityIndicatorView()
class Animations {
    
    private init(){
    }
    public static func Instance() -> Animations {
        return instance
    }
    static let instance : Animations = Animations()
    var state = 0
    
    func shakeTextField(txt: UITextField){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: txt.center.x - 10, y: txt.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: txt.center.x + 10, y: txt.center.y))
        txt.layer.add(animation, forKey: "position")
    }
    
    func shakeTextField(txt: UITextView){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.07
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: txt.center.x - 10, y: txt.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: txt.center.x + 10, y: txt.center.y))
        txt.layer.add(animation, forKey: "position")
    }
}
