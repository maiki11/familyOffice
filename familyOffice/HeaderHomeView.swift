//
//  HeaderHomeView.swift
//  familyOffice
//
//  Created by miguel reina on 06/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

//import Foundation
import UIKit

class HeaderHomeView: UICollectionReusableView{
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var familyImage: UIImageView!
    
    override func layoutSubviews() {
        //familyName.text = context.
        familyImage.layer.cornerRadius = familyImage.frame.size.width/2
        familyImage.clipsToBounds = true
        
    }
    
    
    
}
