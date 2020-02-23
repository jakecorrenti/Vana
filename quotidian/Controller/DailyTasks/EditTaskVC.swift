//
//  EditTaskVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/20/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class EditTaskVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var task = Task()
    var numberOfReminderRows = 1
    
    lazy var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()
    
    var updateLongReminderTime: Date?
    let weekdays: [String] = [
        "Sunday",
        "Monday",
        "Tuesday",
        "Wednesday",
        "Thursday",
        "Friday",
        "Saturday"
    ]
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var tableView: UITableView = {
        let view                 = UITableView(frame: .zero, style: .insetGrouped)
        view.delegate            = self
        view.dataSource          = self
        view.backgroundColor     = Colors.qBG
        view.keyboardDismissMode = .onDrag
        view.register(TextFieldCell.self, forCellReuseIdentifier: Cells.textFieldCell)
        view.register(TextViewCell.self, forCellReuseIdentifier: Cells.textViewCell)
        view.register(TimePickerCell.self, forCellReuseIdentifier: Cells.timePickerCell)
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        return view
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
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
        navigationItem.title = "Edit task"
        view.backgroundColor = Colors.qBG
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
    }
    
    func handleEditReminder() {
        if numberOfReminderRows < 2 {
            numberOfReminderRows += 1
            
            tableView.insertRows(at: [IndexPath(row: numberOfReminderRows - 1, section: 2)], with: .automatic)
        }
    }
    
    func handleDeleteReminder() {
        let timeDisplayCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        timeDisplayCell?.textLabel?.text = "No reminder set"
    }
    
    func handleCollapseReminderCells() {
        numberOfReminderRows -= 1
        
        tableView.deleteRows(at: [IndexPath(row: numberOfReminderRows, section: 2)], with: .automatic)
    }
}

// -----------------------------------------
// MARK: Datasource
// -----------------------------------------

extension EditTaskVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            return numberOfReminderRows
        } else if section == 3 {
            return weekdays.count
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            cell.configure(placeholder: "Enter task name...")
            cell.textField.text = task.title
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textViewCell, for: indexPath) as! TextViewCell
            cell.textView.text  = task.taskDescription
            cell.selectionStyle = .none
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                if task.reminderShortTime == "" {
                    cell.textLabel?.text = "No reminder set"
                } else {
                    cell.textLabel?.text = task.reminderShortTime
                }
                cell.textLabel?.font      = UIFont.systemFont(ofSize: 15)
                cell.textLabel?.textColor = Colors.qDarkGrey
                cell.selectionStyle       = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.timePickerCell, for: indexPath) as! TimePickerCell
                let timeDisplayCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
                if timeDisplayCell?.textLabel?.text == "No reminder set" {
                    cell.datePicker.date = Date()
                } else {
                    cell.datePicker.date = task.reminderLongTime
                }
                cell.delegate = self
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
            cell.textLabel?.text      = weekdays[indexPath.row]
            cell.textLabel?.font       = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.textColor = Colors.qDarkGrey
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension EditTaskVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 {
            return 250
        } else if indexPath == IndexPath(row: 1, section: 2) {
            return 150
        }
        
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "name"
        case 1:
            return "description"
        case 2:
            return "reminder"
        case 3:
            return "repeating days"
        case 4:
            return "checklist items"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 0, section: 2) {
            if numberOfReminderRows < 2 {
                let controller = UIAlertController(title: "Would you like to edit or delete your reminder?", message: nil, preferredStyle: .actionSheet)
                let edit       = UIAlertAction(title: "Edit", style: .default) { _ in
                    self.handleEditReminder()
                }
                let delete     = UIAlertAction(title: "Delete", style: .destructive) { _ in
                    self.handleDeleteReminder()
                }
                let cancel     = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                [edit, delete, cancel].forEach {controller.addAction($0)}
                present(controller, animated: true, completion: nil)
            } else {
                // handle collapsing the cells
                handleCollapseReminderCells()
            }
        }
    }
}

extension EditTaskVC: TimeChangedDelegate {
    func updateTime(time: Date) {
        let timeDisplayCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2))
        timeDisplayCell?.textLabel?.text = formatter.string(from: time)
        
        updateLongReminderTime = time
    }
}
