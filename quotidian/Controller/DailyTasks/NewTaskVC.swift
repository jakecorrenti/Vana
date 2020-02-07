//
//  NewTaskVC.swift
//  quotidian
//
//  Created by Jake Correnti on 1/26/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

protocol TimeChangedDelegate {
    func updateTime(time: Date)
}

protocol RepeatDaysDelegate {
    func getRepeatDays(days: [String])
}

class NewTaskVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var reminderRows   = [1]
    var repeatRows     = [1]
    var subTasks       = [""]
    
    var daysSelected = [String]()
    var weekdayIntSelected = [Int]()
    var fullRemindTime: Date?
    
    var realm: Realm?
    
    let center = UNUserNotificationCenter.current()
    
    lazy var dateFormatter: DateFormatter = {
        let f        = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var tableView: UITableView = {
        let view                 = UITableView(frame: .zero, style: .grouped)
        view.backgroundColor     = Colors.qBG
        view.delegate            = self
        view.dataSource          = self
        view.keyboardDismissMode = .onDrag
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        view.register(TextFieldCell.self, forCellReuseIdentifier: Cells.textFieldCell)
        view.register(TextViewCell.self, forCellReuseIdentifier: Cells.textViewCell)
        view.register(TimePickerCell.self, forCellReuseIdentifier: Cells.timePickerCell)
        return view
    }()
    
    lazy var reminderSwitch: UISwitch = {
        let view         = UISwitch()
        view.onTintColor = Colors.qPurple
        view.addTarget(self, action: #selector(reminderSwitchPressed), for: .valueChanged)
        return view
    }()
    
    lazy var repeatSwitch: UISwitch = {
        let view         = UISwitch()
        view.onTintColor = Colors.qPurple
        view.addTarget(self, action: #selector(repeatSwitchPressed), for: .valueChanged)
        return view
    }()
    
    lazy var removeButton: UIButton = {
        let view = UIButton()
        view.setTitle("Remove", for: .normal)
        view.setTitleColor(Colors.qPurple, for: .normal)
        return view
    }()
    
    // -----------------------------------------
    // MARK: Life Cycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        accessRealm()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
        requestNotificationPermission()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    func setupNavBar() {
        view.backgroundColor = Colors.qBG
        
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Colors.qDarkGrey
        ]
        
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationItem.backBarButtonItem  = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = doneButton
        
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
    }
    
    func requestNotificationPermission() {
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
            }
        }
    }
    
    func setupNotifications(task: Task) {
        //MARK: - IMPLEMENT
        
        let content = UNMutableNotificationContent()
        content.title = "Complete the task: \(task.title)"
        content.body = "Open your Quotidian app to complete your remaining tasks!"
        
        let date = task.reminderLongTime
        
        for day in daysSelected {
            switch day {
            case "Sunday" :
                weekdayIntSelected.append(1)
            case "Monday":
                weekdayIntSelected.append(2)
            case "Tuesday":
                weekdayIntSelected.append(3)
            case "Wednesday":
                weekdayIntSelected.append(4)
            case "Thursday":
                weekdayIntSelected.append(5)
            case "Friday":
                weekdayIntSelected.append(6)
            case "Saturday":
                weekdayIntSelected.append(7)
            default:
                print("")
            }
        }
        
        if weekdayIntSelected.count == 0 {
            let dateComponents = Calendar.current.dateComponents([
                .hour,
                .minute,
            ], from: date)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            
            let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
            
            center.add(request) { (error) in
                if let error = error {
                    print("There was an error: \(error.localizedDescription)")
                }
            }
        } else {
            for weekday in weekdayIntSelected {
                
                
                var dateComponents = Calendar.current.dateComponents([
                    .hour,
                    .minute,
                ], from: date)
                
                dateComponents.weekday = weekday
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
                
                let request = UNNotificationRequest(identifier: task.uid, content: content, trigger: trigger)
                
                center.add(request) { (error) in
                    if let error = error {
                        print("There was an error: \(error.localizedDescription)")
                    }
                }
            }

        }
        
    }
    
    func accessRealm() {
        do {
            realm = try Realm()
        } catch  {
            print("Error accessing Realm Database: \(error.localizedDescription )")
        }
    }
    
    func promptUserForSubTask() {
        let ac = UIAlertController(title: "Checklist item", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Done", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]

            if answer.text != nil || answer.text != " " || !answer.text!.isEmpty {
                self.addTaskToTableView(name: answer.text!)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        ac.addAction(submitAction)
        ac.addAction(cancelAction)

        present(ac, animated: true)
    }
    
    func addTaskToTableView(name: String) {
        subTasks.append(name)
        
        tableView.insertRows(at: [IndexPath(row: subTasks.count - 1, section: 4)], with: .automatic)
        tableView.scrollToRow(at: IndexPath(row: subTasks.count - 1, section: 4), at: .bottom, animated: true)
    }
    
    func createChecklistInstances() -> List<CheckListItem> {
        let checklistItems = List<CheckListItem>()
        
        for item in subTasks {
            let checklistItem         = CheckListItem()
            checklistItem.name        = item
            checklistItem.isCompleted = false
            
            checklistItems.append(checklistItem)
        }
        
        checklistItems.removeFirst()
        return checklistItems
    }
    
    func getTitle() -> String {
        let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        guard let title = titleCell.textField.text else { return "" }
        return title
    }
    
    func getDescription() -> String {
        let descriptionCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextViewCell
        guard let taskDescription = descriptionCell.textView.text else { return "" }
        
        if taskDescription == "Description" { return "" }
        
        return taskDescription
    }
    
    func getReminder() -> String {
        if reminderSwitch.isOn {
            let reminderCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2))
            guard let reminderShortTime = reminderCell?.textLabel?.text else { return "" }
            return reminderShortTime
        }
        return ""
    }
    
    func getRepeatDays() -> List<String> {
        let repeatDays = List<String>()
        if repeatSwitch.isOn {
            for day in daysSelected {
                repeatDays.append(day)
            }
        }
        return repeatDays
    }
    
    func verifyForm() -> Bool {
        if getTitle() == "" {
            return false
        }
        return true
    }
    
    @objc func reminderSwitchPressed() {
        if reminderSwitch.isOn {
            reminderRows.append(1)
            
            tableView.insertRows(at: [IndexPath(row: reminderRows.count - 1, section: 2)], with: .automatic)
            
        } else {
            if reminderRows.count == 3 {
                for _ in 0...1 {
                    reminderRows.removeLast()
                    tableView.deleteRows(at: [IndexPath(row: reminderRows.count, section: 2)], with: .automatic)
                }
            } else {
                reminderRows.removeLast()
                tableView.deleteRows(at: [IndexPath(row: reminderRows.count, section: 2)], with: .automatic)
            }
        }
    }
    
    @objc func repeatSwitchPressed() {
        if repeatSwitch.isOn {
            repeatRows.append(1)
            
            tableView.insertRows(at: [IndexPath(row: repeatRows.count - 1 , section: 3)], with: .automatic)
        } else {
            repeatRows.removeLast()
            tableView.deleteRows(at: [IndexPath(row: repeatRows.count, section: 3)], with: .automatic)
        }
    }
    
    @objc func doneButtonPressed() {
        if verifyForm() {
            let task               = Task()
            task.title             = getTitle()
            task.taskDescription   = getDescription()
            task.reminderShortTime = getReminder()
            task.reminderLongTime  = fullRemindTime ?? Date()
            task.repeatDays        = getRepeatDays()
            task.checkListItems    = createChecklistInstances()
             
            guard let realm = realm else { return }
            try! realm.write {
                realm.add(task)
                
                if task.reminderShortTime != "" {
                    setupNotifications(task: task)
                }
                
                navigationController?.popViewController(animated: true)
            }
        }
    }
}

// -----------------------------------------
// MARK: Datasource
// -----------------------------------------

extension NewTaskVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return reminderRows.count
        } else if section == 3 {
            return repeatRows.count
        } else if section == 4 {
            return subTasks.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            cell.configure(placeholder: "Title")
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textViewCell, for: indexPath) as! TextViewCell
            cell.selectionStyle = .none
            return cell
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.accessoryView        = reminderSwitch
                cell.textLabel?.text      = "Set a reminder"
                cell.textLabel?.font      = UIFont.systemFont(ofSize: 15)
                cell.selectionStyle       = .none
                cell.textLabel?.textColor = Colors.qDarkGrey
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.textLabel?.text          = "\(dateFormatter.string(from: Date()))"
                cell.textLabel?.font          = UIFont.systemFont(ofSize: 15)
                cell.textLabel?.textAlignment = .right
                cell.selectionStyle           = .none
                cell.textLabel?.textColor     = Colors.qDarkGrey
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.timePickerCell, for: indexPath) as! TimePickerCell
                cell.selectionStyle = .none
                cell.delegate       = self
                return cell
            }
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.accessoryView        = repeatSwitch
                cell.textLabel?.text      = "Repeat"
                cell.textLabel?.font      = UIFont.systemFont(ofSize: 15)
                cell.selectionStyle       = .none
                cell.textLabel?.textColor = Colors.qDarkGrey
                return cell
            } else {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: Cells.defaultCell)
                cell.accessoryType        = .disclosureIndicator
                cell.textLabel?.text      = "Days: "
                cell.textLabel?.font      = UIFont.systemFont(ofSize: 15)
                cell.selectionStyle       = .none
                cell.textLabel?.textColor = Colors.qDarkGrey
                return cell
            }
        case 4:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.imageView?.image     = UIImage(systemName: Images.plus)
                cell.textLabel?.text      = "Add checklist item"
                cell.textLabel?.textColor = Colors.qDarkGrey
                cell.textLabel?.font      = UIFont.systemFont(ofSize: 15)
                cell.selectionStyle       = .none
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.textLabel?.text          = subTasks[indexPath.row]
                cell.textLabel?.textColor     = Colors.qDarkGrey
                cell.textLabel?.font          = UIFont.systemFont(ofSize: 15)
                cell.selectionStyle           = .none
                cell.textLabel?.textAlignment = .center
                return cell
            }
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
            return cell
        }
    }
    
    
}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension NewTaskVC : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if indexPath.section == 1 || indexPath == IndexPath(row: 2, section: 2){
            return 150
        }
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath.section {
        case 2:
            if indexPath.row == 1 {
                if reminderRows.count == 2 {
                    reminderRows.append(1)
                    tableView.insertRows(at: [IndexPath(row: reminderRows.count - 1 , section: 2)], with: .automatic)
                } else if reminderRows.count == 3 {
                    reminderRows.removeLast()
                    tableView.deleteRows(at: [IndexPath(row: reminderRows.count, section: 2)], with: .automatic)
                }
            }
        case 3:
            if indexPath.row == 1 {
                let repeatDays      = RepeatDaysSelectionVC()
                repeatDays.delegate = self
                navigationController?.pushViewController(repeatDays, animated: true)
            }
        case 4:
            if indexPath.row == 0 {
                promptUserForSubTask()
            } else if indexPath.row > 0 {
                let alertSheet = UIAlertController(title: "Delete item?", message: "Would you like to delete \"\(subTasks[indexPath.row])\"?", preferredStyle: .actionSheet)

                let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
                    self.subTasks.remove(at: indexPath.row)
                    self.tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 4)], with: .automatic)

                    print(self.subTasks)
                }

                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

                alertSheet.addAction(deleteAction)
                alertSheet.addAction(cancelAction)
                present(alertSheet, animated: true)
            }
            
        default:
            print("The selected indexpath does not exist ")
        }
    }
    
}

// -----------------------------------------
// MARK: Time Updated Delegate
// -----------------------------------------

extension NewTaskVC: TimeChangedDelegate {
    func updateTime(time: Date) {
        if reminderRows.count >= 2 {
            let timeDisplayCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2))
            timeDisplayCell?.textLabel?.text = dateFormatter.string(from: time)
            
            fullRemindTime = time
        }
    }
}

// -----------------------------------------
// MARK: Repeat Days Delegate
// -----------------------------------------

extension NewTaskVC: RepeatDaysDelegate {
    func getRepeatDays(days: [String]) {
        daysSelected = days
        
        var daysString = ""
        
        for day in days {
            daysString += day
            daysString += "  "
        }
        
        if daysString == "Sunday  Monday  Tuesday  Wednesday  Thursday  Friday  Saturday  " {
            daysString = "Every day"
        } else if daysString == "Monday  Tuesday  Wednesday  Thursday  Friday  " {
            daysString = "Weekdays"
        } else if daysString == "Sunday  Saturday  " {
            daysString = "Weekends"
        }
        
        let repeatDaysCell = tableView.cellForRow(at: IndexPath(row: 1, section: 3))
        repeatDaysCell?.detailTextLabel?.text      = daysString
        repeatDaysCell?.detailTextLabel?.textColor = Colors.qDarkGrey
        repeatDaysCell?.detailTextLabel?.font      = UIFont.systemFont(ofSize: 15)
    }
}
