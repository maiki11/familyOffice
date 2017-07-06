//
//  GoalViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 30/06/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//

import UIKit
import ReSwift
import Charts
class GoalViewController: UIViewController, StoreSubscriber, HandleFamilySelected {
   

    let settingLauncher = SettingLauncher()
    typealias StoreSubscriberStateType = GoalState
    var myGoals: [Goal] = []
    
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
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
        store.subscribe(self) {
            subscription in
            subscription.GoalsState
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        store.state.GoalsState.status = .none
        store.unsubscribe(self)
        service.GOAL_SERVICE.removeHandles()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupNavBar(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.handleNew))
        addButton.tintColor = #colorLiteral(red: 1, green: 0.2793949573, blue: 0.1788432287, alpha: 1)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Home"), style: .plain, target: self, action: #selector(self.back))
        let moreButton = UIBarButtonItem(image: #imageLiteral(resourceName: "nav_bar_more_button"), style: .plain, target: self, action:  #selector(self.handleMore))
        
        self.navigationItem.rightBarButtonItems = [moreButton, addButton]
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func selectFamily() {
        if service.USER_SERVICE.users.count > 0, let index = service.FAMILY_SERVICE.families.index(where: {$0.id == service.USER_SERVICE.users[0].familyActive}) {
            let family = service.FAMILY_SERVICE.families[index]
            segmentControl.setTitle("Familia \(family.name!)", forSegmentAt: 1)
            newState(state: store.state.GoalsState)
        }
        
    }
    
    @IBAction func handleChange(_ sender: UISegmentedControl) {
        addObservers()
        newState(state: store.state.GoalsState)
        tableView.reloadData()
    }
    
    func addObservers() -> Void {
        if segmentControl.selectedSegmentIndex == 0 {
            service.GOAL_SERVICE.initObserves(ref: service.GOAL_SERVICE.basePath, actions: [.childAdded, .childRemoved, .childChanged])
        }else{
            service.GOAL_SERVICE.initObserves(ref: "goals/\(service.USER_SERVICE.users[0].familyActive!)", actions: [.childAdded, .childRemoved, .childChanged])
        }
    }
    
    func handleMore(_ sender: Any) {
        settingLauncher.handleFamily = self
        settingLauncher.showSetting()
    }
    func handleNew() -> Void {
        self.performSegue(withIdentifier: "addSegue", sender: nil)
    }
    func back() -> Void {
        self.dismiss(animated: true, completion: nil)
    }
    
    func newState(state: GoalState) {
        if segmentControl.selectedSegmentIndex == 0 {
            myGoals = state.goals[service.USER_SERVICE.users[0].id!] ?? []
        }else{
            myGoals = state.goals[service.USER_SERVICE.users[0].familyActive!] ?? []
        }
       
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            let vc = segue.destination as! AddGoalViewController
            let goal :Goal!
            if sender is Goal {
                vc.bind(goal: sender as! Goal)
                goal = sender as? Goal
            }else{
                goal = Goal()
                if segmentControl.selectedSegmentIndex == 1 {
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
