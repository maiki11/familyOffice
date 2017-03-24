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
    
    var doctorsRef : FIRDatabaseReference!
    var observerId : UInt!
    
    var doctors : [Health.Doctor]! = []
    
    var doctorToEdit: Health.Doctor?
    var indexToEdit: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let user = USER_SERVICE.users[0]
		doctorsRef = REF_USERS.child("\(user.id!)/\(User.kUserHealthKey)/\(Health.kHealthDoctors)")
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        collectionView!.addGestureRecognizer(lpgr)
        self.clearsSelectionOnViewWillAppear = true

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        observerId = doctorsRef.observe(.value, with: {snapshot in
            self.doctors = []
            let iter = snapshot.children
            
            while let doc😘 = iter.nextObject() as? FIRDataSnapshot {
                self.doctors.append(Health.Doctor(snapshot: doc😘))
            }
            self.collectionView!.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        doctorsRef.removeObserver(withHandle: observerId)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        let ctrl = segue.destination as! NewDoctorViewController
        ctrl.editDoctor = self.doctorToEdit
        ctrl.editIndex = self.indexToEdit
        self.doctorToEdit = nil
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
        return doctors.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! DoctorCollectionViewCell
    
        let doctor = doctors[indexPath.row]
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
        
        if indexPath != nil && indexPath!.row < doctors.count {
            let alert = UIAlertController(title: doctors[indexPath!.row].name, message: "¿Qué deseas hacer?", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Eliminar", style: .destructive, handler: {_ in
            	var user = USER_SERVICE.users[0]
                var health = Health(health: user.health ?? [:])
                health.doctors.remove(at: indexPath!.row)
                user.health = health.toDictionary()
                USER_SERVICE.updateUser(user: user)
            }))
            
            alert.addAction(UIAlertAction(title: "Editar", style: .default, handler: {_ in
            	self.doctorToEdit = self.doctors[indexPath!.row]
                self.indexToEdit = indexPath!.row
                self.performSegue(withIdentifier: "addDoctor", sender: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            
            self.present(alert, animated: true, completion: nil)
        }
    }

}
