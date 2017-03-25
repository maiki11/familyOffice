//
//  TextFieldStyles.swift
//  familyOffice
//
//  Created by miguel reina on 24/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit

class TextFieldStyles{
    
    public static func Instance() -> TextFieldStyles {
        return instance
    }

    static let instance : TextFieldStyles = TextFieldStyles()
    
    func borderbottom(textField: UITextField, color: UIColor, width: Float){
        let border = CALayer()
        let width = CGFloat(width)
        border.borderColor = color.cgColor
        border.frame = CGRect(x: 0, y: textField.frame.size.height - width, width:  textField.frame.size.width, height: textField.frame.size.height)
        border.borderWidth = width
        textField.layer.addSublayer(border)
        textField.layer.masksToBounds = true
    }
}
