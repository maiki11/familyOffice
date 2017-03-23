//
//  BaseTableViewCell.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 21/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupViews()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupViews()  {
        
    }

}
