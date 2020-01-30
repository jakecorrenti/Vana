//
//  RepeatDaysSelectionVC.swift
//  quotidian
//
//  Created by Jake Correnti on 1/27/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

enum DaysOfWeek: String {
    case monday    = "Monday"
    case tuesday   = "Tuesday"
    case wednesday = "Wednesday"
    case thursday  = "Thursday"
    case friday    = "Friday"
    case saturday  = "Saturday"
    case sunday    = "Sunday"
}

class RepeatDaysSelectionVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    let daysOfWeek: [DaysOfWeek] = [
        .sunday,
        .monday,
        .tuesday,
        .wednesday,
        .thursday,
        .friday,
        .saturday
    ]
    
    var daysSelected = [String]()
    var delegate: RepeatDaysDelegate?
    
    lazy var tableView: UITableView = {
        let view             = UITableView()
        view.tableFooterView = UIView()
        view.delegate        = self
        view.dataSource      = self
        view.backgroundColor = Colors.qBG
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        return view
    }()
    
    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
    }
    
    func checkCellForAccessoryType(cell: UITableViewCell, day: DaysOfWeek) {
        if cell.accessoryType == .checkmark {
            daysSelected.append(day.rawValue)
        }
    }
    
    @objc func doneButtonPressed() {
        let sundayCell    = tableView.cellForRow(at: IndexPath(row: 0, section: 0))!
        let mondayCell    = tableView.cellForRow(at: IndexPath(row: 1, section: 0))!
        let tuesdayCell   = tableView.cellForRow(at: IndexPath(row: 2, section: 0))!
        let wednesdayCell = tableView.cellForRow(at: IndexPath(row: 3, section: 0))!
        let thursdayCell  = tableView.cellForRow(at: IndexPath(row: 4, section: 0))!
        let fridayCell    = tableView.cellForRow(at: IndexPath(row: 5, section: 0))!
        let saturdayCell  = tableView.cellForRow(at: IndexPath(row: 6, section: 0))!
        
        checkCellForAccessoryType(cell: sundayCell, day: .sunday)
        checkCellForAccessoryType(cell: mondayCell, day: .monday)
        checkCellForAccessoryType(cell: tuesdayCell, day: .tuesday)
        checkCellForAccessoryType(cell: wednesdayCell, day: .wednesday)
        checkCellForAccessoryType(cell: thursdayCell, day: .thursday)
        checkCellForAccessoryType(cell: fridayCell, day: .friday)
        checkCellForAccessoryType(cell: saturdayCell, day: .saturday)
        
        delegate?.getRepeatDays(days: daysSelected)
        navigationController?.popViewController(animated: true)
    }
}

// -----------------------------------------
// MARK: Datasource
// -----------------------------------------

extension RepeatDaysSelectionVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return daysOfWeek.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
        cell.backgroundColor      = Colors.qBG
        cell.selectionStyle       = .none
        cell.textLabel?.text      = daysOfWeek[indexPath.row].rawValue
        cell.textLabel?.font      = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = Colors.qDarkGrey
        cell.accessoryType        = .none
        return cell
    }
    
}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension RepeatDaysSelectionVC : UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.accessoryType == UITableViewCell.AccessoryType.none {
            cell?.accessoryType = .checkmark
        } else {
            cell?.accessoryType = .none
        }
    }
}
