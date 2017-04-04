//
//  DoctorCollectionViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 23/mar/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class DoctorCollectionViewController: UICollectionViewController {
    
    var doctorsUrl: String!
    var userIndex : Int = 0
    var indexToEdit: Int?
    var observers : [NSObjectProtocol?] = [nil, nil, nil]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userIndex == 0 {
            
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
            self.navigationItem.rightBarButtonItem = addButton
            
            let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
            lpgr.minimumPressDuration = 0.5
            lpgr.delaysTouchesBegan = true
            collectionView!.addGestureRecognizer(lpgr)
            self.clearsSelectionOnViewWillAppear = true
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.collectionView?.reloadData()
        
        var user = USER_SERVICE.users[userIndex]
        doctorsUrl = "users/\(user.id!)/health/doctors"
        REF_SERVICE.chilAdded(ref: doctorsUrl)
        REF_SERVICE.childChanged(ref: doctorsUrl)
        REF_SERVICE.chilRemoved(ref: doctorsUrl)
        
        var observerJustAdded = true
        
        observers[0] = NotificationCenter.default
            .addObserver(forName: HEALTHDOCTOR_ADDED, object: nil, queue: nil, using: { doc in
                if observerJustAdded {
                    observerJustAdded = false
                    user.health.doctors.removeAll()
                    user.health.doctors.append(doc.object as! Health.Doctor)
                    USER_SERVICE.users[self.userIndex] = user
                }
            	self.collectionView?.reloadData()
            })
        
        observers[1] = NotificationCenter.default
            .addObserver(forName: HEALTHDOCTOR_UPDATED, object: nil, queue: nil, using: { _ in
            	self.collectionView?.reloadData()
            })
        
        observers[2] = NotificationCenter.default
            .addObserver(forName: HEALTHDOCTOR_REMOVED, object: nil, queue: nil, using: { _ in
            	self.collectionView?.reloadData()
            })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        REF_SERVICE.remove(ref: doctorsUrl)
        
        observers = observers.map({ proto in
        	NotificationCenter.default.removeObserver(proto!)
            return nil
        })
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let ctrl = segue.destination as! NewDoctorViewController
        ctrl.userIndex = self.userIndex
        ctrl.editIndex = self.indexToEdit
        self.indexToEdit = nil
    }
    
    func add(sender: UIBarButtonItem){
        self.performSegue(withIdentifier: "addDoctor", sender: nil)
    }


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return USER_SERVICE.users[userIndex].health.doctors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DoctorCollectionViewCell
    
        let doctor = USER_SERVICE.users[userIndex].health.doctors[indexPath.row]
        cell.doctorName.text = doctor.name
        cell.doctorAddress.text = doctor.address
        cell.doctorPhone.text = doctor.phone
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer){
        let point = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if indexPath != nil && indexPath!.row < USER_SERVICE.users[userIndex].health.doctors.count {
            let alert = UIAlertController(title: USER_SERVICE.users[userIndex].health.doctors[indexPath!.row].name, message: "¿Qué deseas hacer?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: {_ in
            	var user = USER_SERVICE.users[0]
                user.health.doctors.remove(at: indexPath!.row)
                USER_SERVICE.updateUser(user: user)
            }))
            
            alert.addAction(UIAlertAction(title: "Editar", style: .default, handler: {_ in
                self.indexToEdit = indexPath!.row
                self.performSegue(withIdentifier: "addDoctor", sender: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

}
