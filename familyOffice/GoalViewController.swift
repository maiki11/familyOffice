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
import ReSwiftRouter
class GoalViewController: UIViewController, StoreSubscriber, UITabBarDelegate, GoalBindable {
    
    static let identifier = "GoalViewController"
    let settingLauncher = SettingLauncher()
    typealias StoreSubscriberStateType = GoalState
    var goal : Goal!
    var user = store.state.UserState.user
    @IBOutlet weak var pieChart: PieChartView!
    @IBOutlet weak var tableView: UITableView!
    weak var axisFormatDelegate: IAxisValueFormatter?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
        axisFormatDelegate = self
        pieChart.noDataText = "No hay objetivos"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        addObservers()
        
        self.bind()
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
    }
    
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        configuration()
    }
    
    func setupNavBar(){
        let addButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(self.handleEdit))
        addButton.tintColor = #colorLiteral(red: 1, green: 0.2793949573, blue: 0.1788432287, alpha: 1)
        let backButton = UIBarButtonItem(image: #imageLiteral(resourceName: "LeftChevron"), style: .plain, target: self, action: #selector(self.back))
        
        self.navigationItem.rightBarButtonItems = [ addButton]
        
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    
    func configuration() -> Void {
        addObservers()
        newState(state: store.state.GoalsState)
        tableView.reloadData()
    }
    
    func addObservers() -> Void {
        
        
        service.GOAL_SERVICE.initObserves(ref: "goals/\((user?.familyActive!)!)", actions: [ .childChanged])
        
    }
    
    func handleEdit() -> Void {
        self.performSegue(withIdentifier: "addSegue", sender: goal)
    }
    func back() -> Void {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func newState(state: GoalState) {
        user = store.state.UserState.user
        goal = state.goals[(user?.familyActive!)!]?.first(where: {$0.id == goal.id}) ?? nil
        updatePieChartData()
        self.navigationItem.title = goal.title!
        tableView.reloadData()
    }
    func selectFamily() -> Void {
        if let index = store.state.FamilyState.families.index(where: {$0.id == store.state.UserState.user?.familyActive}){
            let family = store.state.FamilyState.families[index]
            self.navigationItem.title = family.name
        }
    }
    
    
    func updatePieChartData()  {
        self.pieChart.clear()
        // 2. generate chart data entries
        let track = ["No", "Si"]
        let goal = [Double(self.goal.members.filter({!$0.value}).count), Double(self.goal.members.filter({$0.value}).count), ]
        
        var entries = [PieChartDataEntry]()
        for (index, value) in goal.enumerated() {
            let entry = PieChartDataEntry()
            entry.y = value
            entry.label = track[index]
            entries.append( entry)
        }
        
        // 3. chart setup
        let set = PieChartDataSet( values: entries, label: "Cuantos la han logrado.")
        // this is custom extension method. Download the code for more details.
        let colors: [UIColor] = [#colorLiteral(red: 0.3098039329, green: 0.01568627544, blue: 0.1294117719, alpha: 1),#colorLiteral(red: 0.1019607857, green: 0.2784313858, blue: 0.400000006, alpha: 1)]
        
        
        set.colors = colors
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        pieChart.noDataText = "No existen objetivos"
        // user interaction
        pieChart.isUserInteractionEnabled = true
        let d = Description()
        pieChart.chartDescription = d
        pieChart.centerText = "Obj."
        pieChart.holeRadiusPercent = 0.5
        pieChart.animate(xAxisDuration: 2.0, yAxisDuration: 2.0, easingOption: .easeInCirc)
        pieChart.transparentCircleColor = UIColor.clear
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue" {
            let vc = segue.destination as! AddGoalViewController
            let goal :Goal!
            if sender is Goal {
                goal = sender as? Goal
                vc.bind(goal: goal)
            }
        }
    }
}

extension GoalViewController: UITableViewDelegate, UITableViewDataSource, IAxisValueFormatter {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goal.members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! GoalTableViewCell
        let key = Array(goal.members.keys)[indexPath.row]
        let member = getUser(id: key)?.name ?? "Cargando..."
        cell.titleLbl.text = member
        cell.accessoryType = goal.members[key]! ? UITableViewCellAccessoryType.checkmark : UITableViewCellAccessoryType.none
        return cell
    }
    
    
    
    func getUser(id: String) -> User? {
        if let user =  store.state.UserState.users.first(where: {$0.id == id}) {
            return user
        }else if id == store.state.UserState.user?.id {
            return user
        }else{
            store.dispatch(GetUserAction(uid: id))
        }
        return nil
        
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        if let family = store.state.FamilyState.families.first(where: {$0.id == user?.familyActive}) {
            let id = family.members[Int(value)]
            if let user = getUser(id: id){
                if user.id == store.state.UserState.user?.id {
                    return "Yo"
                }
                return user.name.components(separatedBy: " ")[0]
            }
        }
        return "none"
    }
}
