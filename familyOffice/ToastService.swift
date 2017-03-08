//
//  ToastService.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 08/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import Toast_Swift
import UIKit

class ToastService {
    public static func Instance() -> ToastService {
        return instance
    }
    private static let instance : ToastService = ToastService()
    private init() {
    }
    
    static func getTopViewControllerAndShowToast(text: String ) -> Void {
        
        if let vc =  UIApplication.shared.delegate?.window??.rootViewController {

            var presented = vc
            
            while let top = presented.presentedViewController {
                presented = top
                presented.view.makeToast(text, duration: 3.0, position: .top)
            }
        }
    }
    
    
    
}
