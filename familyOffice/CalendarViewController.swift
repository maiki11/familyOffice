//
//  CalendarViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//
import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UIGestureRecognizerDelegate {
    var event: Event!
    var dates: [Event] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    var localeChangeObserver : [NSObjectProtocol] = []
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        if UIDevice.current.model.hasPrefix("iPad") {
            self.calendarHeightConstraint.constant = 400
        }
        for item in service.USER_SERVICE.users[0].events! {
            searchEvent(eid: item)
        }
    
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.handleNew))
        addButton.tintColor = #colorLiteral(red: 1, green: 0.2793949573, blue: 0.1788432287, alpha: 1)
        self.navigationItem.rightBarButtonItem = addButton
        self.calendar.accessibilityIdentifier = "calendar"
        
    }
    func tapFunction(sender: UILabel) {
        let center = sender.center
        let point = sender.superview!.convert(center, to:self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: point)
        let cell = self.tableView.cellForRow(at: indexPath!) as! EventTableViewCell
        self.event = cell.event!
        self.performSegue(withIdentifier: "showEventSegue", sender: nil)
        
    }
    func handleNew() {
        self.event =  Event()
        self.performSegue(withIdentifier: "addSegue", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.calendar.select(Date())
        self.tableView.reloadData()
        service.REF_SERVICE.chilAdded(ref: "users/\(service.USER_SERVICE.users[0].id!)/events")
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerSuccess(obj:)), name: notCenter.SUCCESS_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeActions), name: notCenter.USER_NOTIFICATION, object: nil)
    }
    func observeActions() -> Void {
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        service.REF_SERVICE.remove(ref: "users/\(service.USER_SERVICE.users[0].id)/events")
    }
    func observerSuccess(obj: Any) -> Void {
        if let _ = obj as? String {
            self.dates = service.EVENT_SERVICE.events
            self.calendar.reloadData()
        }
    }
    func gotoView(event: Event, segue: String){
        self.event = event
    }
    deinit {
        print("\(#function)")
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let shouldBegin = self.tableView.contentOffset.y <= -self.tableView.contentInset.top
        if shouldBegin {
            let velocity = self.scopeGesture.velocity(in: self.view)
            switch self.calendar.scope {
            case .month:
                return velocity.y < 0
            case .week:
                return velocity.y > 0
            }
        }
        return shouldBegin
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier=="showEventSegue" {
            let viewController = segue.destination as! ShowEventViewController
            viewController.bind(event: self.event)
        }else if segue.identifier == "addSegue" {
             let viewController = segue.destination as! addEventTableViewController
             viewController.bind(event)
        }
    }
}

extension CalendarViewController : UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! EventTableViewCell
        let date = dates[indexPath.row]
        cell.bind(event: date)
        cell.dateSelected.text = Date(string: date.date, formatter: .InternationalFormat)?.string(with: .dayMonthAndYear2)
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? EventTableViewCell else { return }
        
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.calendar.setScope(.week, animated: true )
        self.calendar.layoutIfNeeded()
        self.calendar.reloadData()
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let cell = tableView.cellForRow(at: editActionsForRowAt) as! EventTableViewCell
        self.event = cell.event
        let more = UITableViewRowAction(style: .normal, title: "Ver mas") { action, index in
            
            self.performSegue(withIdentifier: "showEventSegue", sender: nil)
        }
      
        let favorite = UITableViewRowAction(style: .default, title: "Editar") { action, index in
       
            self.performSegue(withIdentifier: "addEventSegue", sender: nil)
            print("favorite button tapped")
        }
        
        let share = UITableViewRowAction(style: .destructive, title: "Eliminar") { action, index in
            print("share button tapped")
        }
        
        return [share, favorite, more]
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}
extension CalendarViewController: FSCalendarDataSource, FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    //Select cell of Calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {

        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        dates = service.EVENT_SERVICE.events.filter({ Date(string: $0.date, formatter: .InternationalFormat)?.string(with: .dayMonthAndYear) == date.string(with: .dayMonthAndYear)})
        tableView.reloadData()
    }
    //Change Page Calendar
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let count = service.EVENT_SERVICE.events.filter({ Date(string: $0.date, formatter: .InternationalFormat)?.string(with: .dayMonthAndYear) == date.string(with: .dayMonthAndYear)}).count
        return count
    }
    
}

