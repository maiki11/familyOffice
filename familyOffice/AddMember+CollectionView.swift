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
        cell.imageMember.image = nil
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = STORAGE_SERVICE.search(url: user.photoURL) {
                DispatchQueue.main.async {
                    
                    cell.imageMember.image = UIImage(data: data)
                }
            }else{
                cell.imageMember.image = #imageLiteral(resourceName: "profile_default")
            }
            
        }
        cell.name.text = user.name
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: IndexPath(row: users.index(where: {$0.id == selected[indexPath.row].id})!+1, section: 0), animated: true)
        selected.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
        reload()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if(indexPath.row != 0){
            
            let selUser = users[indexPath.row-1]
            
            if !selected.contains(where: {$0.id == selUser.id}) {
                selected.append(selUser)
                firstCell.collectionView.insertItems(at: [IndexPath(item: selected.count-1 , section: 0)])
                reload()
            }
        }
    }
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let selUser = users[indexPath.row-1]
        let index = IndexPath(item: selected.index(where: {$0.id == selUser.id})!, section: 0)
        if(indexPath.row != 0){
            selected.remove(at: selected.index(where: {$0.id == selUser.id})!)
            firstCell.collectionView.deleteItems(at: [index])
            reload()
        }
    }
    func reload() -> Void {
        if(selected.count <= 1 ){
            tableView.reloadRows(at: [IndexPathOfFirstRow as IndexPath], with: UITableViewRowAnimation.automatic)
        }
        
    }
    
}
