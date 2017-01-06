//
//  Utility.swift
//  
//
//  Created by Leonardo Durazo on 05/01/17.
//
//

import Foundation
import UIKit
import FirebaseAuth

class Utility {
    
    private init(){
    }
    public static func Instance() -> Utility {
        return instance
    }
    
    static let instance : Utility = Utility()
    var state = 0
    
    func gotoView(view:String, context: UIViewController )  {
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController : UIViewController = storyboard.instantiateViewController(withIdentifier: view)
         context.present(viewController, animated: true, completion: nil)
    }
    
    
}
