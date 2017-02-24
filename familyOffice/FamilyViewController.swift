//
//  FamilyViewController.swift
//  familyOffice
//
//  Created by Miguel Reina y Leonardo Durazo on 13/01/17.
//  Copyright © 2017 Miguel Reina y Leonardo Durazo. All rights reserved.


import UIKit
import FirebaseAuth

class FamilyViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate  {

    
    var members : [User] = []
    var family : Family?
    
    @IBOutlet weak var familyName: UILabel!
    @IBOutlet weak var imageFamily: UIImageView!
    @IBOutlet weak var membersTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        familyName.text = family?.name
        
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
            if let data = STORAGE_SERVICE.search(url: (self.family?.photoURL?.absoluteString)!) {
                self.imageFamily.image = UIImage(data: data)
            }
        }
        
        let lpgr = UILongPressGestureRecognizer(target: self, action:#selector(handleLongPress(gestureReconizer:)))
        membersTable.addGestureRecognizer(lpgr)
        membersTable.contentInset = UIEdgeInsetsMake(20, 0, 0, 0)
        
        let addButton : UIBarButtonItem = UIBarButtonItem(title: "Agregar", style: UIBarButtonItemStyle.plain, target: self, action:#selector(addMemberScreen(sender:)))
        self.navigationItem.rightBarButtonItem = addButton
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        REF_FAMILIES.child((family?.id)!).child("members").observe(.childRemoved, with: { (snapshot) -> Void in
            if(snapshot.exists()){
                if let obj = self.members.filter({$0.id == snapshot.key as String}).first {
                    // do something with namedFoot
                    FAMILY_SERVICE.getFamilies(key: (self.family?.id)!)
                    FAMILY_SERVICE.removeMember(member: obj, family: self.family!)
                    let index = self.members.enumerated().filter({$0.element.id == snapshot.key}).first?.offset
                    self.members.remove(at: index!)
                    self.membersTable.deleteRows(at: [IndexPath(row: index!, section: 0)], with: UITableViewRowAnimation.automatic)
                    if self.family?.admin == snapshot.key {
                        FAMILY_SERVICE.getFamilies(key: (self.family?.id)!)
                    }
                }
            }
            
        })
        
        REF_FAMILIES.child((family?.id)!).child("members").observe(.childAdded, with: { (snapshot) -> Void in
            if(snapshot.exists()){
                self.existUser(id: snapshot.key)
            }
            
        })
        
        
        self.membersTable.reloadData()
        NotificationCenter.default.addObserver(forName: USERS_NOTIFICATION, object: nil, queue: nil){ obj in
            if let user : User = obj.object as? User {
                 self.existUser(id: user.id)
            }
           
        }
        NotificationCenter.default.addObserver(forName: FAMILYUPDATED_NOTIFICATION, object: nil, queue: nil){ notification in
            self.membersTable.reloadData()
        }
        
    }
    func existUser(id: String) -> Void {
        if let user = USER_SERVICE.users.filter({$0.id == id}).first {
            if !self.members.contains(where: {$0.id == user.id}){
                self.members.append(user)
                self.membersTable.insertRows(at: [NSIndexPath(row: self.members.count-1, section: 0) as IndexPath], with: .fade)
            }
            self.addMembers(user: user)
        }else{
            USER_SERVICE.getUser(uid: id)
        }
    }
    func addMemberScreen(sender: UIBarButtonItem) -> Void {
        self.performSegue(withIdentifier: "addMembersScreen", sender: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: USERS_NOTIFICATION, object: nil)
        REF_FAMILIES.child((family?.id)!).child("members").removeAllObservers()
        
    }
    override func didReceiveMemoryWarning(){
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FamilyMemberTableViewCell
        let member = self.members[indexPath.row]
        cell.name.text = member.name
        DispatchQueue.global(qos: .userInitiated).async {
            if let data = STORAGE_SERVICE.search(url: member.photoURL) {
                DispatchQueue.main.async {
                    cell.activityIndicator.stopAnimating()
                    cell.memberImage.image = UIImage(data: data)
                }
                cell.memberImage.image = UIImage(data: data)
            }else {
                cell.activityIndicator.stopAnimating()
                cell.memberImage.image = #imageLiteral(resourceName: "profile_default")
            }
        }
        cell.phone.text = member.phone
        if(FAMILY_SERVICE.families.filter({$0.id == family?.id}).first?.admin == member.id){
            cell.adminlabel.isHidden = false
        }else{
            cell.adminlabel.isHidden = true
        }
        
        return cell
    }

    //Long press
    func handleLongPress(gestureReconizer: UILongPressGestureRecognizer) {
        let point: CGPoint = gestureReconizer.location(in: self.membersTable)
        let indexPath = self.membersTable?.indexPathForRow(at: point)
        
        if (indexPath != nil && (indexPath?.row)! < members.count) {
            switch gestureReconizer.state {
            case .began:
                
                let user = members[(indexPath?.row)!]
                if(user.id == USER_SERVICE.user?.id){
                    break
                }
                // create the alert
                let alert = UIAlertController(title: user.name, message: "¿Qué deseas hacer?", preferredStyle: UIAlertControllerStyle.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Ver Perfil", style: UIAlertActionStyle.default, handler: {action in
                    DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                        
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancelar", style: UIAlertActionStyle.cancel, handler: nil))
                if(family?.admin == FIRAuth.auth()?.currentUser?.uid){
                    alert.addAction(UIAlertAction(title: "Remover de la familia", style: UIAlertActionStyle.destructive, handler:  { action in
                        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                            //ELiminar usuario de la familia
                            FAMILY_SERVICE.removeMember(member: user, family: self.family!)
                            self.members.remove(at: (indexPath?.row)!)
                            self.membersTable.deleteRows(at: [indexPath!], with: UITableViewRowAnimation.fade)
                        }
                        
                    }))
                }
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
                break
            case .ended:
                print("termine")
                break
            default:
                break
            }
        }
    }
    @IBAction func handleExitFamily(_ sender: UIButton) {
        FAMILY_SERVICE.exitFamily(family: family!, uid: (FIRAuth.auth()?.currentUser?.uid)!)
        if FAMILY_SERVICE.families.count > 0 {
            UTILITY_SERVICE.gotoView(view: "TabBarControllerView", context: self)
        }else{
            UTILITY_SERVICE.gotoView(view: "RegisterFamilyView", context: self)
        }
        
    }

    func addMembers(user: User){
        if let index = FAMILY_SERVICE.families.index(where: {$0.id == self.family?.id}) {
            let memberDict : [String:Bool]  = FAMILY_SERVICE.families[index].members as! [String : Bool]
            FAMILY_SERVICE.families[index].members = memberDict as NSDictionary?
            self.family?.members = memberDict as NSDictionary?
        }
    }

    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "addMembersScreen"){
            let viewController  = segue.destination as! AddMembersTableViewController
            viewController.family = family!
        }
    }
    
}
