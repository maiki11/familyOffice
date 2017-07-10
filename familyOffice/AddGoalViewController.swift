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
import ReSwift
import ReSwiftRouter
class AddGoalViewController: UIViewController, GoalBindable, StoreSubscriber, Routable{
    static let identifier = "AddGoalViewController"
    var goal: Goal!
    var type = 0
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var endDateDP: UIDatePicker!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var types = [("Deportivo","sport"),("Religión","religion"),("Escolar","school"),("Negocios","business-1"),("Alimentación","eat"),("Salud","health-1")]
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Crear Objetivo"
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        setupNavBar()
        self.bind(goal: goal)
        store.subscribe(self) {
            state in
            state.GoalsState
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        store.unsubscribe(self)
        
    }
    
    func setupNavBar(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.save))
        let updateButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.update))
        if goal.title != "" {
            self.navigationItem.rightBarButtonItem = updateButton
        }else{
            self.navigationItem.rightBarButtonItem = addButton
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func save() -> Void {
        
        guard let title = titleTxt.text, !title.isEmpty else {
            return
        }
        goal.title = title
        goal.endDate = endDateDP.date.string(with: .InternationalFormat)
        store.dispatch(InsertGoalAction(goal: goal))
    }
    
    func update() -> Void {
        
        guard let title = titleTxt.text, !title.isEmpty else {
            return
        }
        goal.title = title
        goal.endDate = endDateDP.date.string(with: .InternationalFormat)
        store.dispatch(UpdateGoalAction(goal: goal))
    }
    
    func newState(state: GoalState) {
        switch state.status {
        case .finished:
            self.view.hideToastActivity()
            _ = self.navigationController?.popViewController(animated: true)
            break
        case .loading:
            self.view.makeToastActivity(.center)
            break
        case .none:
            break
        default: break
            
        }
    }
    
    typealias StoreSubscriberStateType = GoalState

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
        if goal.category == indexPath.item {
            cell.checkimage.isHidden = false
        }else{
            cell.checkimage.isHidden = true
        }
        cell.photo.image = UIImage(named: obj.1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goal.category = indexPath.item
        collectionView.reloadData()
    }
    
}


