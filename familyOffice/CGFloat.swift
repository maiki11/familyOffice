//
//  CGFloat.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/05/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation

extension Float {
    static func random() -> Float {
        return CFloat(arc4random()) / CFloat(UInt32.max)
    }
}
