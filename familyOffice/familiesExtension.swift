//
//  familiesExtension.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 13/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit

extension ProfileUserViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return families.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FamilyCollectionViewCell
        let family = families[indexPath.row]
        cell.name.text = family.name
        // Bounce back to the main thread to update the UI
        if !(family.photoURL?.isEmpty)! {
            cell.imageFamily.loadImage(urlString: (family.photoURL)!)
        }
        return cell
    }
    func setFamiliesInComun() -> Void {
        
        if index > 0 {
            for familyId in (USER_SERVICE.users[index].families?.allKeys)! {
                if let family : Family = FAMILY_SERVICE.families.first(where: {$0.id == familyId as! String}){
                    if !self.families.contains(where: {$0.id == familyId as! String}){
                        
                        self.families.append(family)                    }
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = CGFloat(families.count)
        
        //If the cell count is zero, no point in calculating anything.
        if cellCount > 0 {
            let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
            let cellWidth = flowLayout.itemSize.width + flowLayout.minimumInteritemSpacing
            
            //20.00 was just extra spacing I wanted to add to my cell.
            let totalCellWidth = cellWidth*cellCount + 20.00 * (cellCount-1)
            let contentWidth = collectionView.frame.size.width - collectionView.contentInset.left - collectionView.contentInset.right
            
            if (totalCellWidth < contentWidth) {
                //If the number of cells that exist take up less room than the
                // collection view width... then there is an actual point to centering the.
                
                //Calculate the right amount of padding to center the cells.
                let padding = (contentWidth - totalCellWidth) / 2.0
                return UIEdgeInsetsMake(0, padding, 0, padding)
            } else {
                //Pretty much if the number of cells that exist take up
                // more room than the actual collectionView width there is no
                // point in trying to center them. So we leave the default behavior.
                return UIEdgeInsetsMake(0, 40, 0, 40)
            }
        }
        
        return UIEdgeInsets.zero
    }
    
   
    
}
