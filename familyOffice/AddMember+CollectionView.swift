//
//  AddMember+CollectionView.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 08/02/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import Foundation
import UIKit

extension AddMembersTableViewController:  UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return selected.count
    }
    
    internal func collectionView(_ collectionView: UICollectionView,
                                 cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellMember", for: indexPath) as! memberSelectedCollectionViewCell
        
        let user = selected[indexPath.row]
        if let data = STORAGE_SERVICE.search(url: user.photoURL) {
            cell.imageMember.image = UIImage(data: data)
        }else{
            cell.imageMember.image = #imageLiteral(resourceName: "profile_default")
        }
        cell.imageMember.layer.cornerRadius = cell.imageMember.frame.size.width/2
        cell.imageMember.clipsToBounds = true
        cell.name.text = user.name
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelectOnTable(id: selected[indexPath.row].id)
        selected.remove(at: indexPath.row)
        reloal(type: true)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row != 0){
            let selUser = users[indexPath.row-1]
            if(duplicate(id: selUser.id)){
                selected.append(selUser)
                reloal(type: true)
            }
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selUser = users[indexPath.row-1]
        if(indexPath.row != 0){
            
            selected.remove(at: search(id: selUser.id))
            
            reloal(type: false)
        }
    }
    func reloal(type: Bool) -> Void {
    
        
        if(selected.count >= 1){
            tableView.reloadRows(at: [IndexPathOfFirstRow as IndexPath], with: UITableViewRowAnimation.fade)
        }else if(selected.count == 0){
            tableView.reloadRows(at: [IndexPathOfFirstRow as IndexPath], with: UITableViewRowAnimation.none)
        }
        
        
    }
    
    func didSelectOnTable(id: String){
        var index = 1
        for item in users {
            if(item.id == id){
                tableView.deselectRow(at: NSIndexPath(row: index, section: 0) as IndexPath, animated: true)
                return
            }
            index+=1
        }
    }
    
}
