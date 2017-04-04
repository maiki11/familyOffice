//
//  MedsCollectionViewController.swift
//  familyOffice
//
//  Created by Nan Montaño on 15/mar/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class MedsCollectionViewController: UICollectionViewController {
    
    let medNameLabelTag = 123
    let medDoseLabelTag = 124
    let medLapseLabelTag = 125
    
    var userIndex : Int = 0
    var editIndex: Int?
    var observers : [NSObjectProtocol] = []
    var medsUrl : String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if userIndex == 0 {
            let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
            lpgr.minimumPressDuration = 0.5
            lpgr.delaysTouchesBegan = true
            collectionView!.addGestureRecognizer(lpgr)
            self.clearsSelectionOnViewWillAppear = true
            
            let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
            
            self.navigationItem.rightBarButtonItem = addButton
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        collectionView!.reloadData()
        
        var user = USER_SERVICE.users[userIndex]
        medsUrl = "users/\(user.id!)/health/meds"
        REF_SERVICE.chilAdded(ref: medsUrl)
        REF_SERVICE.chilRemoved(ref: medsUrl)
        REF_SERVICE.childChanged(ref: medsUrl)
        
        var justAttachedListener = true
        
        let addedObs = NotificationCenter.default
            .addObserver(forName: HEALTHMED_ADDED, object: nil, queue: nil, using: { med in
                if justAttachedListener {
                    justAttachedListener = false
                    user.health.meds.removeAll()
                    user.health.meds.append(med.object as! Health.Med)
                    USER_SERVICE.users[self.userIndex] = user
                }
            	self.collectionView!.reloadData()
        	})
        
        let updatedObs = NotificationCenter.default
            .addObserver(forName: HEALTHMED_UPDATED, object: nil, queue: nil, using: { _ in
                self.collectionView!.reloadData()
            })
        
        let removedObs = NotificationCenter.default
            .addObserver(forName: HEALTHMED_REMOVED, object: nil, queue: nil, using: { _ in
                self.collectionView!.reloadData()
            })
        
        observers.append(addedObs)
        observers.append(updatedObs)
        observers.append(removedObs)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        REF_SERVICE.remove(ref: medsUrl)
        
        observers.forEach({ proto in
        	NotificationCenter.default.removeObserver(proto)
        })
        observers.removeAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationCtrl = segue.destination as! NewMedTableViewController
        destinationCtrl.userIndex = userIndex
        destinationCtrl.index = editIndex
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return USER_SERVICE.users[userIndex].health.meds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MedCollectionViewCell
    
        let med = USER_SERVICE.users[userIndex].health.meds[indexPath.row]
        
        let medType = med.type
        let medImage = UIImage(named: medType)?.withRenderingMode(.alwaysTemplate)
        cell.medImageView.image = medImage
        cell.medImageView.tintColor = UIColor.red
        cell.medNameView.text = med.name
        var dose = med.dose
        if(dose.contains("m")){
            dose += medType == "pill" ? "g" : "l"
        }
        let minutes = med.lapse
        var lapse = "\(minutes) minutos"
        if minutes > 60*24*30 {
            lapse = "\(minutes/60/24/30) meses"
        } else if minutes > 60*24 {
            lapse = "\(minutes/60/24) dias"
        } else if minutes > 60 {
            lapse = "\(minutes/60) horas"
        }
        cell.medDoseView.text = "\(dose) cada \(lapse)"
        
        return cell
    }
    
    func add(sender: UIBarButtonItem) {
        self.editIndex = nil
        self.performSegue(withIdentifier: "addSegue", sender: nil)
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let point: CGPoint = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if (indexPath != nil && (indexPath?.row)! < USER_SERVICE.users[userIndex].health.meds.count) {
            switch gestureRecognizer.state {
            case .began:
                let med = USER_SERVICE.users[userIndex].health.meds[(indexPath?.row)!]
                
                // create the alert
                let alert = UIAlertController(title: med.name, message: "¿Qué deseas hacer?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Editar", style: UIAlertActionStyle.default, handler: {action in
                    self.editIndex = indexPath?.row
                    self.performSegue(withIdentifier: "addSegue", sender: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Eliminar", style: UIAlertActionStyle.destructive, handler:  { action in
                    USER_SERVICE.users[self.userIndex].health.meds.remove(at: indexPath!.row)
                    USER_SERVICE.updateUser(user: USER_SERVICE.users[self.userIndex])
					
                }))
            
                // show the alert
                self.present(alert, animated: true, completion: nil)
                break
            default:
                break
            }
        }
    }


}
