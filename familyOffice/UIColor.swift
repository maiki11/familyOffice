//
//  UIColor.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/05/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit


extension UIColor {
    static func random() -> UIColor {
        return UIColor(colorLiteralRed: 255.0, green: .random(), blue: .random(), alpha: 1.0)
    }
}
