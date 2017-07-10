//
//  GoalViewContro/Users/ldurazo/Documents/proyectos/familyOffice/familyOffice/GoalViewController.swiftller.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import ReSwift
import Charts
<<<<<<< HEAD
class GoalViewController: UIViewController, StoreSubscriber, HandleFamilySelected {
   

    let settingLauncher = SettingLauncher()
    typealias StoreSubscriberStateType = GoalState
    var myGoals: [Goal] = []
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
=======
import ReSwiftRouter
class GoalViewController: UIViewController, StoreSubscriber, UITabBarDelegate {
    
    static let identifier = "GoalViewController"
    let settingLauncher = SettingLauncher()
    typealias StoreSubscriberStateType = GoalState
    var myGoals = [Goal]()
    
    @IBOutlet weak var barChart: BarChartView!
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tabBar: UITabBar!
>>>>>>> master
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
<<<<<<< HEAD
        pieChart.noDataText = "No hay objetivos"
        updateChartData()
        // Do any additional setup after loading the view.
    }
    func updateChartData()  {
        
        // 2. generate chart data entries
        let track = ["Incompletas", "Completas"]
        let money = [40.0, 60.0]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Objetivos")
        // this is custom extension method. Download the code for more details.
        var colors: [UIColor] = []
        
        for _ in 0..<money.count {
            let red = Double(arc4random_uniform(256))
            let green = Double(arc4random_uniform(256))
            let blue = Double(arc4random_uniform(256))
            let color = UIColor(red: CGFloat(127), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: 1)
            colors.append(color)
        }
        set.colors = colors
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        pieChart.noDataText = "No data available"
        // user interaction
        pieChart.isUserInteractionEnabled = true
        
        let d = Description()
        d.text = "Personales"
        pieChart.chartDescription = d
        pieChart.centerText = "Obj."
        pieChart.holeRadiusPercent = 0.2
        pieChart.transparentCircleColor = UIColor.clear
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addObservers()
        selectFamily()
=======
        tabBar.delegate = self
        pieChart.noDataText = "No hay objetivos"
        tabBar.selectedItem = tabBar.items?[0]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addObservers()
        
>>>>>>> master
        store.subscribe(self) {
            subscription in
            subscription.GoalsState
        }
    }
<<<<<<< HEAD

=======
    
>>>>>>> master
    override func viewWillDisappear(_ animated: Bool) {
        store.state.GoalsState.status = .none
        store.unsubscribe(self)
        service.GOAL_SERVICE.removeHandles()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
<<<<<<< HEAD
        // Dispose of any resources that can be recreated.
=======
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        configuration()
>>>>>>> master
    }
    
    func setupNavBar(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.handleNew))
        addButton.tintColor = #colorLiteral(red: 1, green: 0.2793949573, blue: 0.1788432287, alpha: 1)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Home"), style: .plain, target: self, action: #selector(self.back))
        let moreButton = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_bar_more_button"), style: .plain, target: self, action:  #selector(self.handleMore))
        
        self.navigationItem.rightBarButtonItems = [moreButton, addButton]
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
<<<<<<< HEAD
    func selectFamily() {
        if service.USER_SERVICE.users.count > 0, let index = service.FAMILY_SERVICE.families.index(where: {$0.id == service.USER_SERVICE.users[0].familyActive}) {
            let family = service.FAMILY_SERVICE.families[index]
            segmentControl.setTitle("Familia \(family.name!)", forSegmentAt: 1)
            newState(state: store.state.GoalsState)
        }
        
    }
    
    @IBAction func handleChange(_ sender: UISegmentedControl) {
=======
    
    func configuration() -> Void {
>>>>>>> master
        addObservers()
        newState(state: store.state.GoalsState)
        tableView.reloadData()
    }
    
    func addObservers() -> Void {
<<<<<<< HEAD
        if segmentControl.selectedSegmentIndex == 0 {
=======
        if tabBar.selectedItem?.tag == 0 {
>>>>>>> master
            service.GOAL_SERVICE.initObserves(ref: service.GOAL_SERVICE.basePath, actions: [.childAdded, .childRemoved, .childChanged])
        }else{
            service.GOAL_SERVICE.initObserves(ref: "goals/\(service.USER_SERVICE.users[0].familyActive!)", actions: [.childAdded, .childRemoved, .childChanged])
        }
    }
    
    func handleMore(_ sender: Any) {
<<<<<<< HEAD
        settingLauncher.handleFamily = self
=======
>>>>>>> master
        settingLauncher.showSetting()
    }
    func handleNew() -> Void {
        self.performSegue(withIdentifier: "addSegue", sender: nil)
    }
    func back() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    func newState(state: GoalState) {
<<<<<<< HEAD
        if segmentControl.selectedSegmentIndex == 0 {
            myGoals = state.goals[service.USER_SERVICE.users[0].id!] ?? []
        }else{
            myGoals = state.goals[service.USER_SERVICE.users[0].familyActive!] ?? []
        }
       
        tableView.reloadData()
    }
    
=======
        if tabBar.selectedItem?.tag == 0 {
            myGoals = state.goals[service.USER_SERVICE.users[0].id!] ?? []
            barChart.isHidden = true
            pieChart.isHidden = false
            updatePieChartData()
        }else{
            myGoals = state.goals[service.USER_SERVICE.users[0].familyActive!] ?? []
            barChart.isHidden = false
            pieChart.isHidden = true
        }
        selectFamily()
        tableView.reloadData()
    }
    func selectFamily() -> Void {
        if let index = store.state.FamilyState.families.index(where: {$0.id == store.state.UserState.user?.familyActive}){
            let family = store.state.FamilyState.families[index]
            self.navigationItem.title = family.name
        }
    }
    func updateChartWithData() {
        var dataEntries: [BarChartDataEntry] = []
        
        //
    }
    
    func updatePieChartData()  {
        
        // 2. generate chart data entries
        let track = ["Incompletas", "Completas"]
        let money = [Double(myGoals.filter({!$0.done}).count), Double(myGoals.filter({$0.done}).count), ]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in money.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Objetivos")
        // this is custom extension method. Download the code for more details.
        let colors: [UIColor] = [#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1),#colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)]
        
        
        set.colors = colors
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        pieChart.noDataText = "No existen objetivos"
        // user interaction
        pieChart.isUserInteractionEnabled = true
        var family: Family!
        
        if let index = service.FAMILY_SERVICE.families.index(where: {$0.id == service.USER_SERVICE.users[0].familyActive}) {
            family = service.FAMILY_SERVICE.families[index]
        }
        let text = tabBar.selectedItem?.tag == 0 ? "Personales" : "Familia \(family.name!)"
        let d = Description()
        d.text = text
        pieChart.chartDescription = d
        pieChart.centerText = "Obj."
        pieChart.holeRadiusPercent = 0.5
        pieChart.transparentCircleColor = UIColor.clear
        
    }
>>>>>>> master
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            let vc = segue.destination as! AddGoalViewController
            let goal :Goal!
            if sender is Goal {
<<<<<<< HEAD
                vc.bind(goal: sender as! Goal)
                goal = sender as? Goal
            }else{
                goal = Goal()
                if segmentControl.selectedSegmentIndex == 1 {
=======
                goal = sender as? Goal
                vc.bind(goal: goal)
                
            }else{
                goal = Goal()
                if tabBar.selectedItem?.tag  == 1 {
>>>>>>> master
                    goal.type = 1
                }
                vc.bind(goal: goal )
            }
            
        }
    }
}

extension GoalViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myGoals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GoalTableViewCell
        let goal = myGoals[indexPath.row]
        cell.bind(goal: goal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let goal = myGoals[indexPath.row]
        self.performSegue(withIdentifier: "addSegue", sender: goal)
    }
}
