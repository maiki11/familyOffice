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

protocol DateProtocol: class {
    func selectedDate(date: Date) -> Void
}


class AddGoalViewController: UIViewController, GoalBindable, StoreSubscriber, UIGestureRecognizerDelegate, DateProtocol{
    static let identifier = "AddGoalViewController"
    var goal: Goal!
    var type = 0
    let padding = UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 0)
    @IBOutlet weak var titleTxt: UITextField!
    @IBOutlet weak var endDateLbl: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var finishLbl: UILabel!
    var types = [("Deportivo","sport"),("Religión","religion"),("Escolar","school"),("Negocios","business-1"),("Alimentación","eat"),("Salud","health-1")]
   
    @IBAction func handleChange(_ sender: UITextField) {
        self.goal.title = self.titleTxt.text
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        endDateLbl.layer.borderWidth = 1
        endDateLbl.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        endDateLbl.layer.cornerRadius = 4
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.tap(_:)))
        tap.delegate = self
        endDateLbl.isUserInteractionEnabled = true
        endDateLbl.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }
    
    func tap(_ gestureRecognizer: UITapGestureRecognizer) -> Void {
        self.performSegue(withIdentifier: "toDatePicker", sender: nil)
    }
    func selectedDate(date: Date) {
        self.goal.endDate = date.string(with: .InternationalFormat)
        print(goal.toDictionary())
        self.bind(goal: goal)
    }
    override func viewWillAppear(_ animated: Bool) {
        setupNavBar()
        self.bind(goal: goal)
        if !goal.title.isEmpty{
             self.navigationItem.title = "Actualizar"
        }else{
            self.navigationItem.title = "Agregar"
        }
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
        store.dispatch(InsertGoalAction(goal: goal))
    }
    
    func update() -> Void {
        
        guard let title = titleTxt.text, !title.isEmpty else {
            return
        }
        goal.title = title
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationNavController = (segue.destination as? UINavigationController){
            if let datePickerVC = destinationNavController.viewControllers.first as? CalendarOpenViewController{
                datePickerVC.dateToSelect = Date(string: endDateLbl.text!, formatter: .dayMonthAndYear2)
                datePickerVC.dateDelegate = self
                
            }
        }
    }

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
            cell.checkimage.backgroundColor = UIColor.clear
            cell.checkimage.alpha = 1
            cell.layer.borderWidth = 3.0
            cell.layer.borderColor = #colorLiteral(red: 0.8078431487, green: 0.02745098062, blue: 0.3333333433, alpha: 1).cgColor
        }else{
            cell.checkimage.backgroundColor = UIColor.black
            cell.checkimage.alpha = 0.6
            cell.layer.borderWidth = 0.0
        }
        cell.photo.image = UIImage(named: obj.1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        goal.category = indexPath.item
        collectionView.reloadData()
    }
    
}


