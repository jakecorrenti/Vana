//
//  NewTaskVC.swift
//  quotidian
//
//  Created by Jake Correnti on 1/26/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

// -----------------------------------------
// MARK: Custom Delegates
// -----------------------------------------

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
    
    let dbManager: StorageContext = RealmStorageContext()
    
    var selectedList = UserList() // use this to assign to the task's list property
    private var doneButton = UIBarButtonItem()
    
    private var numberOfReminderRows = 1
    private var numberOfRepeatRows = 1
    private var selectedTimeFullFormat: Date?
    private var repeatingDays = List<String>()
    
    lazy var formatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()
    
    lazy var hourFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "hh"
        return f
    }()
    
    lazy var minuteFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "mm"
        return f
    }()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = Colors.qBG
        view.delegate = self
        view.dataSource = self
        view.keyboardDismissMode = .onDrag
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        view.register(TextFieldCell.self, forCellReuseIdentifier: Cells.textFieldCell)
        view.register(TimePickerCell.self, forCellReuseIdentifier: Cells.timePickerCell)
        view.register(TextViewCell.self, forCellReuseIdentifier: Cells.textViewCell)
        return view
    }()
    
    lazy var isReminderSwitch: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.onTintColor = Colors.qPurple
        view.addTarget(self, action: #selector(reminderSwitchValueChanged), for: .valueChanged)
        return view
    }()
    
    lazy var isRepeatingSwitch: UISwitch = {
        let view = UISwitch()
        view.isOn = false
        view.onTintColor = Colors.qPurple
        view.isEnabled = false
        view.addTarget(self, action: #selector(repeatSwitchValueChanged), for: .valueChanged)
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
    
    private func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationItem.title = "New task"
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        doneButton.isEnabled = false
        navigationItem.rightBarButtonItem = doneButton
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)

    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 0))
    }
    
    // -----------------------------------------
    // MARK: Cell Interactions
    // -----------------------------------------
    
    private func onSetReminder() {
        isRepeatingSwitch.isEnabled = true
        
        numberOfReminderRows += 1
        
        tableView.insertRows(at: [IndexPath(row: numberOfReminderRows - 1, section: 2)], with: .automatic)
        tableView.scrollToRow(at: IndexPath(row: numberOfReminderRows - 1, section: 2), at: .bottom, animated: true)
    }
    
    private func onSetRepeatDays() {
        numberOfRepeatRows += 1
        
        tableView.insertRows(at: [IndexPath(row: numberOfRepeatRows - 1, section: 3)], with: .automatic)
        tableView.scrollToRow(at: IndexPath(row: numberOfRepeatRows - 1, section: 3), at: .bottom, animated: true)
    }

    private func onRemoveReminder() {
        isRepeatingSwitch.isEnabled = false
        isRepeatingSwitch.isOn = false
        
        if numberOfRepeatRows == 2 {
            onRemoveRepeatDays()
        }
        
        if numberOfReminderRows == 2 {
            numberOfReminderRows -= 1
            
            tableView.deleteRows(at: [IndexPath(row: numberOfReminderRows, section: 2)], with: .automatic)
        } else if numberOfReminderRows == 3 {
            (0...1).forEach { _ in
                numberOfReminderRows -= 1
                tableView.deleteRows(at: [IndexPath(row: numberOfReminderRows, section: 2)], with: .automatic)
            }
        }
    }

    private func onRemoveRepeatDays() {
        numberOfRepeatRows -= 1
        
        tableView.deleteRows(at: [IndexPath(row: numberOfRepeatRows, section: 3)], with: .automatic)
    }
    
    // -----------------------------------------
    // MARK: Access cell values
    // -----------------------------------------
    
    private func getTaskName() -> String {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        guard let text = cell.textField.text else { return "Error accessing the task's name" }
        return text
    }
    
    private func getTaskNotes() -> String {
        let cell = tableView.cellForRow(at: IndexPath(row: 1, section: 1)) as! TextViewCell
        guard let text = cell.textView.text else { return "There are no notes for this task" }
        return text
    }
    
    private func getRepeatingTaskHourComponent() -> Int {
        return Calendar.current.component(.hour, from: selectedTimeFullFormat!)
    }
    
    private func getRepeatingTaskMinuteComponent() -> Int {
        return Calendar.current.component(.minute, from: selectedTimeFullFormat!)
    }
    
    private func getRepeatingTaskDayComponent() -> [Int]? {
        if repeatingDays != nil {
            var dayComponents = [Int]()
            
            for day in repeatingDays {
                switch day {
                case "Sunday":
                    dayComponents.append(1)
                case "Monday":
                    dayComponents.append(2)
                case "Tuesday":
                    dayComponents.append(3)
                case "Wednesday":
                    dayComponents.append(4)
                case "Thursday":
                    dayComponents.append(5)
                case "Friday":
                    dayComponents.append(6)
                case "Saturday":
                    dayComponents.append(7)
                default:
                    return nil
                }
            }
            return dayComponents
        }
        return nil
    }
    
    private func setupNotifications() {
        let notificationsManager = LocalNotificationsManager()
        
        if getRepeatingTaskDayComponent() != nil {
            
            var notifications = [LocalNotification]()
            
            for day in getRepeatingTaskDayComponent()! {
                
                var notificationDateComponents = DateComponents()
                notificationDateComponents.weekday = day
                notificationDateComponents.hour = getRepeatingTaskHourComponent()
                notificationDateComponents.minute = getRepeatingTaskMinuteComponent()

                notifications.append(LocalNotification(id: UUID().uuidString, title: "Complete: \(getTaskName())", dateTime: notificationDateComponents, isRepeating: isRepeatingSwitch.isOn))
                
            }
            
            notificationsManager.notifications = notifications
            notificationsManager.schedule()
            
        } else {
            
            var notificationDateComponents = DateComponents()
            notificationDateComponents.hour = getRepeatingTaskHourComponent()
            notificationDateComponents.minute = getRepeatingTaskMinuteComponent()

            notificationsManager.notifications = [
                LocalNotification(id: UUID().uuidString, title: "Complete: \(getTaskName())", dateTime: notificationDateComponents, isRepeating: isRepeatingSwitch.isOn)
            ]

            notificationsManager.schedule()
        }
    }
    
    // -----------------------------------------
    // MARK: View Interactions
    // -----------------------------------------
    
    @objc func doneButtonPressed() {
        let task = Task()
        task.name = getTaskName()
        task.userList = selectedList
        task.notes = getTaskNotes()
        task.repeatDays = repeatingDays
        
        if selectedTimeFullFormat != nil {
            task.reminderLongTime = selectedTimeFullFormat!
            task.reminderShortTime = formatter.string(from: selectedTimeFullFormat!)
            setupNotifications()
        }
        
        try? selectedList.append(task: task)
        try? dbManager.save(object: task)
        navigationController?.popViewController(animated: true)
    }
    
    @objc func reminderSwitchValueChanged() {
        if isReminderSwitch.isOn {
            onSetReminder()
        } else {
            onRemoveReminder()
        }
    }
    
    @objc func repeatSwitchValueChanged() {
        if isRepeatingSwitch.isOn {
            onSetRepeatDays()
        } else {
            onRemoveRepeatDays()
        }
    }
    
    @objc func continuouslyCheckNameTFContents() {
        let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        let content = cell.textField.text
        
        if content == "" || content == " " || content == nil {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
}

// -----------------------------------------
// MARK: Data Source
// -----------------------------------------

extension NewTaskVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        case 2:
            return numberOfReminderRows
        case 3:
            return numberOfRepeatRows
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            cell.configure(placeholder: "Task name...")
            cell.selectionStyle = .none
            cell.textField.addTarget(self, action: #selector(continuouslyCheckNameTFContents), for: .editingChanged)
            return cell
        case 1:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.textLabel?.text = "Notes:"
                cell.textLabel?.textColor = Colors.qDarkGrey
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textViewCell, for: indexPath) as! TextViewCell
                return cell
            }
        case 2:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.textLabel?.text = "Set reminder"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.textLabel?.textColor = Colors.qDarkGrey
                cell.accessoryView = isReminderSwitch
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.textLabel?.text = formatter.string(from: Date())
                cell.textLabel?.textColor = Colors.qDarkGrey
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.textLabel?.textAlignment = .right
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.timePickerCell, for: indexPath) as! TimePickerCell
                cell.delegate = self
                return cell
            }
        case 3:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.textLabel?.text = "Set repeating days"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.textLabel?.textColor = Colors.qDarkGrey
                cell.accessoryView = isRepeatingSwitch
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 {
                let cell = UITableViewCell(style: .value1, reuseIdentifier: Cells.defaultCell)
                cell.selectionStyle = .none
                cell.textLabel?.text = "Days selected:"
                cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
                cell.textLabel?.textColor = Colors.qDarkGrey
                cell.accessoryType = .disclosureIndicator
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
    }
}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension NewTaskVC : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 2, section: 2) {
            return 150
        }
        if indexPath == IndexPath(row: 1, section: 1) {
            return 200
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        switch indexPath {
        case IndexPath(row: 1, section: 2):
            if numberOfReminderRows < 3 {
                numberOfReminderRows += 1
                tableView.insertRows(at: [IndexPath(row: numberOfReminderRows - 1, section: 2)], with: .automatic)
                tableView.scrollToRow(at: IndexPath(row: numberOfReminderRows - 1, section: 2), at: .bottom, animated: true)
            } else {
                numberOfReminderRows -= 1
                tableView.deleteRows(at: [IndexPath(row: numberOfReminderRows, section: 2)], with: .automatic)
                tableView.scrollToRow(at: IndexPath(row: numberOfReminderRows - 1, section: 2), at: .bottom, animated: true)
            }
        case IndexPath(row: 1, section: 3):
            let repeating = RepeatDaysSelectionVC()
            repeating.delegate = self
            navigationController?.pushViewController(repeating, animated: true)
        default:
            print("Selecting this index has no functionality")
        }
    }
}

// -----------------------------------------
// MARK: Custom Protocols
// -----------------------------------------

extension NewTaskVC: TimeChangedDelegate {
    func updateTime(time: Date) {
        let timeDisplayCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2))
        timeDisplayCell?.textLabel?.text = formatter.string(from: time)
        selectedTimeFullFormat = time 
    }
}

extension NewTaskVC: RepeatDaysDelegate {
    func getRepeatDays(days: [String]) {
        print(days)
        
        days.forEach {repeatingDays.append($0)}
        
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
