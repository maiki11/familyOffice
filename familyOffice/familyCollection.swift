//
//  familyCollection.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 15/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit
extension SelectCategoryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,  UIGestureRecognizerDelegate{
    

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return families.count + 1
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < families.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! FamiliesPreCollectionViewCell
            let family = families[indexPath.item]
            cell.name.text = family.name
            cell.check.layer.cornerRadius = 15
            cell.check.layer.borderWidth = 3
            cell.check.layer.borderColor = UIColor(red: 255.0/255, green: 255.0/255, blue: 255.0/255, alpha: 1).cgColor
            // Bounce back to the main thread to update the UI
            if !(family.photoURL?.isEmpty)! {
                cell.image.loadImage(urlString: (family.photoURL)!)
            }
            cell.check.isHidden = true
            cell.name.textColor = #colorLiteral(red: 0.6941176471, green: 0.6941176471, blue: 0.6941176471, alpha: 1)

            cell.image.layer.borderWidth = 1
            cell.image.layer.borderColor = UIColor( red: 204/255, green: 204/255, blue:204.0/255, alpha: 1.0 ).cgColor
            cell.image.layer.cornerRadius = 5
            if family.id == store.state.UserState.user?.familyActive {
                cell.check.isHidden = false
                cell.name.textColor = #colorLiteral(red: 0.3137395978, green: 0.1694342792, blue: 0.5204931498, alpha: 1)
            }
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "addCell", for: indexPath)
       
        return cell
        
    }
    func addFamily(family: Family) -> Void {
        self.familiesCollection.insertItems(at: [IndexPath(item: store.state.FamilyState.families.count-1, section: 0)])
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        //Where elements_count is the count of all your items in that
        //Collection view...
        let cellCount = CGFloat(families.count+1)
        
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

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row == families.count){
            self.performSegue(withIdentifier: "registerFamilySegue", sender: nil)
        }else{
            let family = families[(indexPath.row)]
            self.toggleSelect(family: family)
            self.familiesCollection.reloadData()
            
        }
    }
    func toggleSelect(family: Family){
        service.USER_SVC.selectFamily(family: family)
    }
    
}
