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
        
        let user = Constants.Services.USER_SERVICE.users[0]
        fam = Constants.Services.FAMILY_SERVICE.families.first(where: { $0.id == user.familyActive })
        membersId = fam!.members
//        let myIdIndex = membersId.index(where: { $0 == user.id! })
//        membersId.remove(at: myIdIndex!)
//        membersId.insert(user.id!, at: 0)
        
        for id in membersId {
            if !Constants.Services.USER_SERVICE.users.contains(where: {$0.id == id}) {
                Constants.Services.USER_SERVICE.getUser(uid: id)
            }
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
            .addObserver(forName: Constants.NotificationCenter.USER_NOTIFICATION, object: nil, queue: nil, using: {_ in
            	self.membersCollectionView.reloadData()
            })
    }
    override func viewDidAppear(_ animated: Bool) {
        membersCollectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredHorizontally)
    }
    func membersWillDisappear(){
        NotificationCenter.default.removeObserver(membersObserver!)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
  
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = zip(Constants.Services.USER_SERVICE.users, membersId).map({$0.0.id == $0.1}).count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = membersCollectionView.dequeueReusableCell(withReuseIdentifier: "memberCell", for: indexPath) as! HealthMemberCollectionViewCell
        let user = Constants.Services.USER_SERVICE.users.first(where: { $0.id == membersId[indexPath.item] })

        if user != nil{
            cell.bind(userModel: user!, filter: "blackwhite")
        }
      
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HealthMemberCollectionViewCell
        cell.selectedMember.isHidden = false
        cell.profileImage.loadImage(urlString: (cell.userModel?.photoURL)!)
        userIndex = Constants.Services.USER_SERVICE.users.index(where: { $0.id! == membersId[indexPath.row] })!
        elems = Constants.Services.USER_SERVICE.users[userIndex].health.elements.filter({ $0.type == categorySelected })
        categoryTableView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! HealthMemberCollectionViewCell
        cell.selectedMember.isHidden = true
        cell.profileImage.loadImage(urlString: (cell.userModel?.photoURL)!,filter: "blackwhite")
    }
    
}
