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
    
    var meds : [NSDictionary] = []
    var editMed : NSDictionary?
    var editIndex: Int?
    
    var medsRef: FIRDatabaseReference?
    var refHandle: UInt?
    
    override func viewDidLoad() {
        super.viewDidLoad()
		
//        let userDictionary = USER_SERVICE.users[0].toDictionary()
//        let healthDictionary : NSDictionary = userDictionary.value(forKey: User.kUserHealthKey) as! NSDictionary
//        if let _meds = healthDictionary.value(forKey: Health.kHealthMeds) as? [NSDictionary] {
//            meds = _meds
//        }
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(gestureRecognizer:)))
        lpgr.minimumPressDuration = 0.5
        lpgr.delaysTouchesBegan = true
        collectionView!.addGestureRecognizer(lpgr)
        self.clearsSelectionOnViewWillAppear = true
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(add(sender:)))
        
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let userId = USER_SERVICE.users[0].id!
        medsRef = REF_USERS.child("\(userId)/health/meds")
        refHandle = medsRef!.observe(.value, with: {snapshot in
            self.meds = snapshot.value as? [NSDictionary] ?? []
            self.collectionView!.reloadData()
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        medsRef?.removeObserver(withHandle: refHandle!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationCtrl = segue.destination as! NewMedTableViewController
        destinationCtrl.med = editMed
        destinationCtrl.index = editIndex
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return meds.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MedCollectionViewCell
    
        let med = meds[indexPath.row]
        
        let medType = med[Health.Med.kMedType] as! String
        let medImage = UIImage(named: medType)?.withRenderingMode(.alwaysTemplate)
        cell.medImageView.image = medImage
        cell.medImageView.tintColor = UIColor.red
        cell.medNameView.text = med[Health.Med.kMedName] as? String
        var dose = med[Health.Med.kMedDose] as! String
        if(dose.contains("m")){
            dose += medType == "pill" ? "g" : "l"
        }
        let minutes = med[Health.Med.kMedLapse] as! Int
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
        self.editMed = nil
        self.performSegue(withIdentifier: "addSegue", sender: nil)
    }
    
    func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let point: CGPoint = gestureRecognizer.location(in: self.collectionView)
        let indexPath = self.collectionView?.indexPathForItem(at: point)
        
        if (indexPath != nil && (indexPath?.row)! < meds.count) {
            switch gestureRecognizer.state {
            case .began:
                let med = meds[(indexPath?.row)!]
                
                // create the alert
                let alert = UIAlertController(title: med["name"] as? String, message: "¿Qué deseas hacer?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Editar", style: UIAlertActionStyle.default, handler: {action in
                    self.editMed = med
                    self.editIndex = indexPath?.row
                    self.performSegue(withIdentifier: "addSegue", sender: nil)
                }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
                alert.addAction(UIAlertAction(title: "Eliminar", style: UIAlertActionStyle.destructive, handler:  { action in
                    self.meds.remove(at: indexPath!.row)
                    var user = USER_SERVICE.users[0]
                    let health = user.health!
                    health.setValue(self.meds, forKey: Health.kHealthMeds)
                    user.health = health
                    USER_SERVICE.updateUser(user: user)
					
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
