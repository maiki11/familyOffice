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
        for item in Constants.Services.USER_SERVICE.users[0].events! {
            searchEvent(eid: item)
        }
    
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        let barButton = UIBarButtonItem(title: "Nuevo", style: .plain, target: self, action: #selector(self.handleNewEvent))
        self.navigationItem.rightBarButtonItem = barButton
        // For UITest
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.calendar.select(Date())
        self.tableView.reloadData()
        for item in Constants.Services.USER_SERVICE.users[0].events! {
            searchEvent(eid: item)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.observerSuccess(obj:)), name: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.observeActions), name: Constants.NotificationCenter.USER_NOTIFICATION, object: nil)
    }
    func observeActions() -> Void {
        self.tableView.reloadData()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }
    func observerSuccess(obj: Any) -> Void {
        if let _ = obj as? String {
            self.dates = Constants.Services.EVENT_SERVICE.events
            self.calendar.reloadData()
        }
    }
    func gotoView(event: Event, segue: String){
        self.event = event
    }
    deinit {
        print("\(#function)")
    }
    
    func handleNewEvent() -> Void {
        self.event = Event(id: "",title: "", description: "", date: Date().string(with: .InternationalFormat), endDate: Date().addingTimeInterval(60 * 60).string(with: .InternationalFormat) , priority: 0, members: [], reminder: Date().addingTimeInterval(60*60*(-1)).string(with: .InternationalFormat))
        self.performSegue(withIdentifier: "addEventSegue", sender: nil)
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
        }else if segue.identifier == "addEventSegue" {
             let viewController = segue.destination as! AddEventViewController
             viewController.bind(event: self.event)
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
        cell.count.text = String(indexPath.row +  1)
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
        more.backgroundColor = .lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Editar") { action, index in
       
            self.performSegue(withIdentifier: "addEventSegue", sender: nil)
            print("favorite button tapped")
        }
        favorite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Eliminar") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = .blue
        
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
        dates = Constants.Services.EVENT_SERVICE.events.filter({ Date(string: $0.date, formatter: .InternationalFormat)?.string(with: .dayMonthAndYear) == date.string(with: .dayMonthAndYear)})
        tableView.reloadData()
    }
    //Change Page Calendar
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
    }
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let count = Constants.Services.EVENT_SERVICE.events.filter({ Date(string: $0.date, formatter: .InternationalFormat)?.string(with: .dayMonthAndYear) == date.string(with: .dayMonthAndYear)}).count
        return count
    }
    
}

