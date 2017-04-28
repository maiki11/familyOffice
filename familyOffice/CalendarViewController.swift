//
//  CalendarViewController.swift
//  familyOffice
//
//  Created by Leonardo Durazo on 23/03/17.
//  Copyright © 2017 Leonardo Durazo. All rights reserved.
//
import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, FSCalendarDataSource, FSCalendarDelegate, UIGestureRecognizerDelegate {

    var dates: [Event] = []
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var calendar: FSCalendar!
    var localeChangeObserver : [NSObjectProtocol] = []
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    
    fileprivate lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy MM dd"
        return formatter
    }()
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
        self.calendar.select(Date())
        
        self.view.addGestureRecognizer(self.scopeGesture)
        self.tableView.panGestureRecognizer.require(toFail: self.scopeGesture)
        self.calendar.scope = .week
        let barButton = UIBarButtonItem(title: "Nuevo", style: .plain, target: self, action: #selector(self.handleNewEvent))
        self.navigationItem.rightBarButtonItem = barButton
        // For UITest
        self.calendar.accessibilityIdentifier = "calendar"
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        for item in Constants.Services.USER_SERVICE.users[0].events! {
            searchEvent(eid: item)
        }
        
        localeChangeObserver.append( NotificationCenter.default.addObserver(forName: Constants.NotificationCenter.SUCCESS_NOTIFICATION, object: nil, queue: nil){ obj in
            if let _ = obj as? String {
                self.dates = Constants.Services.EVENT_SERVICE.events
                self.calendar.reloadData()
            }
        })
        localeChangeObserver.append( NotificationCenter.default.addObserver(forName: Constants.NotificationCenter.USER_NOTIFICATION, object: nil, queue: nil){ obj in
            self.tableView.reloadData()
        })
    }
    

    deinit {
        print("\(#function)")
    }
    
    func handleNewEvent() -> Void {
        self.performSegue(withIdentifier: "addEventSegue", sender: nil)
    }
    // MARK:- UIGestureRecognizerDelegate
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
    
    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        self.calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    //Select cell of Calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        print("did select date \(date.string(with: .dayMonthAndYear))")
        let selectedDates = calendar.selectedDates.map({self.dateFormatter.string(from: $0)})
        print("selected dates is \(selectedDates)")
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        dates = Constants.Services.EVENT_SERVICE.events.filter({ Date(string: $0.date, formatter: .dayMonthYearHourMinute)?.string(with: .dayMonthAndYear) == date.string(with: .dayMonthAndYear)})
        tableView.reloadData()
    }
    //Change Page Calendar
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        print("\(self.dateFormatter.string(from: calendar.currentPage))")
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let count = Constants.Services.EVENT_SERVICE.events.filter({ Date(string: $0.date, formatter: .dayMonthYearHourMinute)?.string(with: .dayMonthAndYear) == date.string(with: .dayMonthAndYear)}).count
        return count
    }
}

extension CalendarViewController {
    // MARK:- UITableViewDataSource
    
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

    
    // MARK:- UITableViewDelegate
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? EventTableViewCell else { return }
        tableViewCell.setCollectionViewDataSourceDelegate(dataSourceDelegate: self, forRow: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.calendar.setScope(.week, animated: true )
        self.calendar.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
}

