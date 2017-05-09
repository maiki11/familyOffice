//
//  HealthOmniViewController_Members.swift
//  familyOffice
//
//  Created by Nan Montaño on 05/abr/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit

extension HealthOmniViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func initMembers(){
        
        membersCollectionView.delegate = self
        membersCollectionView.dataSource = self
        membersCollectionView.layer.cornerRadius = 2
        
        let user = USER_SERVICE.users[0]
        fam = FAMILY_SERVICE.families.first(where: { $0.id == user.familyActive })
        membersId = fam!.members!.allKeys as! [String]
        let myIdIndex = membersId.index(where: { $0 == user.id! })
        membersId.remove(at: myIdIndex!)
        membersId.insert(user.id!, at: 0)
        
        for id in membersId {
            USER_SERVICE.getUser(uid: id)
        }
//        let indexPath = IndexPath(item: 0, section: 0)
//        membersCollectionView.selectItem(at: indexPath, animated: true, scrollPosition: .bottom)
        
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        let indexPath = IndexPath(item: 0, section: 0)
//        if(USER_SERVICE.users[0].id == membersId[indexPath.row]){
//            collectionView(membersCollectionView, didSelectItemAt: indexPath)
//        }
//    }
    
    func membersWillAppear(){
        membersObserver = NotificationCenter.default
            .addObserver(forName: USER_NOTIFICATION, object: nil, queue: nil, using: {_ in
            	self.membersCollectionView.reloadData()
            })
    }
    
    func membersWillDisappear(){
        NotificationCenter.default.removeObserver(membersObserver!)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return membersId.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = membersCollectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! HealthMemberCollectionViewCell
        let user = USER_SERVICE.users.first(where: { $0.id == membersId[indexPath.row] })
        
        if user != nil && !(user!.photoURL.isEmpty) {
            cell.image.loadImage(urlString: user!.photoURL)
        }else{
            cell.image.image = #imageLiteral(resourceName: "profile_default")
        }
        
        if (indexPath.item == 0){
//            self.collectionView(membersCollectionView, didSelectItemAt: IndexPath.init(row: 0, section: 0))
//            collectionView.selectItem(at: IndexPath.init(row: 0, section: 0), animated: true, scrollPosition: UICollectionViewScrollPosition.centeredHorizontally)
            print("----ITEM--------------")
            print(indexPath.item)
            print("------------------")
            cell.selectedMember.isHidden = false
        }
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HealthMemberCollectionViewCell
        cell.selectedMember.isHidden = false
        userIndex = USER_SERVICE.users.index(where: { $0.id! == membersId[indexPath.row] })!
        elems = USER_SERVICE.users[userIndex].health.elements.filter({ $0.type == categorySelected })
        categoryTableView.reloadData()
        print("----IMAGE--------------")
        print(cell.image)
        print("------------------")
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HealthMemberCollectionViewCell
        cell.selectedMember.isHidden = true
    }
    
}
