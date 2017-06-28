//
//  AddGoalViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 21/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import Toast_Swift
import Firebase
class AddGoalViewController: UIViewController, GoalBindable{
    var types = [("Deportivo","sport"),("Religión","religion"),("Escolar","school"),("Negocios","business-1"),("Alimentación","eat"),("Salud","health-1")]
    var goal: Goal!
    @IBOutlet weak var titleLbl: UITextField!
    @IBOutlet weak var endDateDP: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.save))
        self.navigationItem.rightBarButtonItem = addButton
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func save() -> Void {
        
        guard let title = titleLbl.text, !title.isEmpty else {
            return
        }

        goal.title = title
        goal.endDate = endDateDP.date.string(with: .InternationalFormat)
        
        self.view.makeToastActivity(.center)
        service.UTILITY_SERVICE.disabledView()
        
        let key = Constants.FirDatabase.REF.childByAutoId().key
        goal.id = key
        service.GOAL_SERVICE.insert("goals/\(service.USER_SERVICE.users[0].id!)/\(key)", value: goal.toDictionary(), callback: {ref in
            if ref is FIRDatabaseReference {
                
            }
            self.view.hideToastActivity()
            service.UTILITY_SERVICE.enabledView()
        })
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension AddGoalViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! typeiconCollectionViewCell
        let obj = types[indexPath.row]
        cell.titleLbl.text = obj.0
        if goal.type == indexPath.item {
            cell.checkimage.isHidden = false
        }else{
            cell.checkimage.isHidden = true
        }
        cell.photo.image = UIImage(named: obj.1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goal.type = indexPath.item
        collectionView.reloadData()
    }
    
}


