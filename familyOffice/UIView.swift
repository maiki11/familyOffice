//
//  UIView.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 17/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

extension UIView {
    func addContraintWithFormat(format: String, views: UIView...)  {
        var viewsDictionary = [String:UIView]()
        for (index,view) in views.enumerated() {
            let key = "v\(index)"
            view.translatesAutoresizingMaskIntoConstraints = false
            viewsDictionary[key] = view
        }
       
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutFormatOptions(), metrics: nil, views: viewsDictionary))
    }
}
