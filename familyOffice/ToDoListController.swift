//
//  ToDoListController.swift
//  familyOffice
//
//  Created by Ernesto Salazar on 6/29/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import ReSwift
import Firebase

class ToDoListController: UITableViewController,UIViewControllerPreviewingDelegate {
    
    var items : [ToDoList.ToDoItem] = []
    var userId = service.USER_SERVICE.users[0].id!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(service.USER_SERVICE.users[0])
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.handleNew))
        addButton.tintColor = #colorLiteral(red: 1, green: 0.2793949573, blue: 0.1788432287, alpha: 1)
        self.navigationItem.rightBarButtonItem = addButton
        
        // Do any additional setup after loading the view.
    
        
        if( traitCollection.forceTouchCapability == .available){
            registerForPreviewing(with: self, sourceView: view)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleNew() -> Void {
        self.performSegue(withIdentifier: "addSegue", sender: nil)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.items.count
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.items[indexPath.row]
        let cellID = "ToDoItemCell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ToDoItemCell
        
        cell.title.text = item.title
        
        if item.status == "Pendiente" {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let didAction = UITableViewRowAction(style: .normal, title: self.items[indexPath.row].status == "Finalizada" ? "Retomar" : "Finalizar") { (action, indexPath) in
            //Cambiar status en Farabase
            self.items[indexPath.row].status = self.items[indexPath.row].status == "Pendiente" ? "Finalizada" : "Pendiente"
            
            store.dispatch(UpdateToDoListItemAction(item:self.items[indexPath.row]))
            
        }
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Eliminar") { (action, indexPath) in
            store.dispatch(DeleteToDoListItemAction(item: self.items[indexPath.row]))
//            let alert = UIAlertController(title: "Eliminar", message: "", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: {_ in
//                
//            }))
//            self.present(alert, animated: true, completion: nil)
        }
        
        return [didAction, deleteAction]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showItemDetails"{
            if let indexPath = self.tableView.indexPathForSelectedRow{
                let selectedItem = self.items[indexPath.row]
                let detailsViewController = segue.destination as! ItemDetailViewController
                detailsViewController.item = selectedItem
            }
        }
    }
    
    // MARK: - PreviewingDeleate.
    // 3D touch en cada elemento de la tabla
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
        guard let indexPath = tableView?.indexPathForRow(at: location) else {return nil}
        
        guard let cell = tableView?.cellForRow(at: indexPath) else {return nil}
        
        guard let detailVC = storyboard?.instantiateViewController(withIdentifier: "ItemDetailViewController") as? ItemDetailViewController else {return nil}
        
        let item = self.items[indexPath.row]
        detailVC.item = item
        
        detailVC.preferredContentSize = CGSize(width: 0.0, height: 600)
        
        previewingContext.sourceRect = cell.frame
        
        return detailVC
    }
    
    func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
        
        show(viewControllerToCommit, sender: self)
        
    }
}

extension ToDoListController: StoreSubscriber{
    typealias StoreSubscriberStateType = ToDoListState
    
    override func viewWillAppear(_ animated: Bool) {
        service.TODO_SERVICE.initObserves(ref: "todolist/\(userId)", actions: [.childAdded, .childChanged, .childRemoved])
        
        store.subscribe(self){
            state in state.ToDoListState
        }
    }
    
    
    
    func newState(state: ToDoListState) {
        items = state.items[userId] ?? []
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        store.state.ToDoListState.status = .none
        store.unsubscribe(self)
        service.TODO_SERVICE.removeHandles()
    }
}

