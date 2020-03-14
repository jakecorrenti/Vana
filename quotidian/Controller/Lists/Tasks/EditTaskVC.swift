//
//  EditTaskVC.swift
//  quotidian
//
//  Created by Jake Correnti on 3/6/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class EditTaskVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var selectedTask = Task()
    var numberOfReminderRows = 1
    private var originalSelectedDays = [String]()
    lazy private var updatedReminderTime = self.selectedTask.reminderLongTime
    private var updatedNotificationIDS = List<String>()
    private var updatedTask = Task()
    
    lazy private var shortFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "h:mm a"
        return f
    }()
    
    lazy private var dayAndTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEEE MMMM d, h:mm a"
        return f
    }()
    
    private var weekdays: [String] = [
        "Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"
    ]
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    var doneButton = UIBarButtonItem()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = Colors.qBG
        view.delegate = self
        view.dataSource = self
        view.keyboardDismissMode = .onDrag
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        view.register(TextFieldCell.self, forCellReuseIdentifier: Cells.textFieldCell)
        view.register(TextViewCell.self, forCellReuseIdentifier: Cells.textViewCell)
        view.register(TimePickerCell.self, forCellReuseIdentifier: Cells.timePickerCell)
        return view
    }()
    
    lazy var reminderSwitch: UISwitch  = {
        let view = UISwitch()
        view.onTintColor = Colors.qPurple
        view.addTarget(self, action: #selector(reminderSwitchValueChanged), for: .valueChanged)
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
        
        selectedTask.repeatDays.forEach { originalSelectedDays.append($0) }
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationItem.title = "Edit task"
        
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        if selectedTask.reminderShortTime == "" {
            reminderSwitch.isOn = false
        } else {
            reminderSwitch.isOn = true
        }
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
    }
    
    private func onSetReminder() {
        numberOfReminderRows += 1
        
        tableView.insertRows(at: [IndexPath(row: numberOfReminderRows - 1, section: 2)], with: .automatic)
    }
    
    private func onRemoveReminder() {
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
    
    private func getName() -> String {
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        return nameCell.textField.text ?? ""
    }
    
    private func getNotes() -> String {
        let notesCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextViewCell
        return notesCell.textView.text ?? ""
    }
    
    private func getRepeatingDaysAsList() -> List<String> {
        let days = List<String>()
        originalSelectedDays.forEach { days.append($0) }
        return days
    }
    
    /*
     TODO:
     - remove all old notifications from que that are related to the current task object ✅
     - remove all old notification ids from the related task object
     - create new notifications based on the new task data
     - assign new notification ids to related task object
     */
    
    private func removeCurrentPendingNotificationRequests() {
        var ids = [String]()
        var matchingIDs = [String]()
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { (notifications) in
            print(notifications.count)
            notifications.forEach { ids.append($0.identifier)}
        }
        
        while ids.count == 0 {
            // loops through until the ids are populated to ensure that the data used is representing actual data
        }
        
        for id in ids {
            for notificationID in selectedTask.notificationID {
                if id == notificationID {
                    matchingIDs.append(id)
                }
            }
        }
        
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: matchingIDs)
        
    }
    
    private func createUpdatedTaskObject() {
        updatedTask.name = getName()
        updatedTask.notes = getNotes()
        updatedTask.uid = selectedTask.uid
        updatedTask.reminderShortTime = shortFormatter.string(from: updatedReminderTime)
        updatedTask.reminderLongTime = updatedReminderTime
        updatedTask.repeatDays = getRepeatingDaysAsList()
    }
    
    private func createUpdatedNotifications() {
        if reminderSwitch.isOn {
            let notificationsManager = LocalNotificationsManager()
            
            if updatedTask.getRepeatingDayComponents() != [Int]() {
                
                var notifications = [LocalNotification]()
                
                for day in updatedTask.getRepeatingDayComponents() {
                    
                    var notificationDateComponents = DateComponents()
                    notificationDateComponents.weekday = day
                    notificationDateComponents.hour = updatedTask.getTaskHourComponent()
                    notificationDateComponents.minute = updatedTask.getTaskMinuteComponent()

                    let id = UUID().uuidString
                    
                    notifications.append(LocalNotification(id: id, title: "Complete: \(getName())", dateTime: notificationDateComponents, isRepeating: true))
                    
                    updatedNotificationIDS.append(id)
                    
                }
                
                notificationsManager.notifications = notifications
                notificationsManager.schedule()
                
            } else {
                
                var notificationDateComponents = DateComponents()
                notificationDateComponents.hour = updatedTask.getTaskHourComponent()
                notificationDateComponents.minute = updatedTask.getTaskMinuteComponent()
                notificationDateComponents.day = updatedTask.getTaskDayOfMonthComponent()
                notificationDateComponents.month = updatedTask.getTaskMonthComponent()
                
                let id = UUID().uuidString

                notificationsManager.notifications = [
                    LocalNotification(id: id, title: "Complete: \(getName())", dateTime: notificationDateComponents, isRepeating: false)
                ]
                
                updatedNotificationIDS.append(id)
                notificationsManager.schedule()
            }
            
            updatedTask.notificationID = updatedNotificationIDS
        } else {
            updatedTask.notificationID = List<String>()
            updatedTask.repeatDays = List<String>()
            updatedTask.reminderShortTime = ""
            updatedTask.reminderLongTime = selectedTask.reminderLongTime
        }
    }
    
    @objc func verifyNameHasContents() {
        let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        let name = nameCell.textField.text
        
        if name == "" || name == " " || name == nil {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    @objc func reminderSwitchValueChanged() {
        if reminderSwitch.isOn {
            onSetReminder()
        } else {
            onRemoveReminder()
        }
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonPressed() {
        let dbManager: StorageContext = RealmStorageContext()
        // scroll to top to prevent name cell contents from being nil since it is not in the que
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: false)
        createUpdatedTaskObject()
        createUpdatedNotifications()
        try? dbManager.update(object: updatedTask)
        navigationController?.popViewController(animated: true)
    }
}

// -----------------------------------------
// MARK: DataSource
// -----------------------------------------

extension EditTaskVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return numberOfReminderRows
        } else if section == 3 {
            return 7
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            cell.textField.text = selectedTask.name
            cell.selectionStyle = .none
            cell.textField.addTarget(self, action: #selector(verifyNameHasContents), for: .editingChanged)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textViewCell, for: indexPath) as! TextViewCell
            if selectedTask.notes == "" {
                cell.textView.text = "Notes..."
                cell.textView.textColor = .lightGray
            } else {
                cell.textView.text = selectedTask.notes
            }
            cell.textView.delegate = self
            cell.selectionStyle = .none
            return cell
        case 2:
            
            //TODO: convert this if-else conditional into a switch statement
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                cell.textLabel?.text = "Set reminder"
                cell.textLabel?.textColor = Colors.qDarkGrey
                cell.textLabel?.font = .systemFont(ofSize: 15)
                cell.accessoryView = reminderSwitch
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 1 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
                
                if selectedTask.reminderShortTime == "" {
                    cell.textLabel?.text = dayAndTimeFormatter.string(from: Date())
                } else {
                    cell.textLabel?.text = dayAndTimeFormatter.string(from: selectedTask.reminderLongTime)
                }
                
                cell.textLabel?.textColor = Colors.qDarkGrey
                cell.textLabel?.font = .systemFont(ofSize: 15)
                cell.textLabel?.textAlignment = .right
                cell.selectionStyle = .none
                return cell
            } else if indexPath.row == 2 {
                let cell = tableView.dequeueReusableCell(withIdentifier: Cells.timePickerCell, for: indexPath) as! TimePickerCell
                cell.delegate = self
                
                if selectedTask.reminderShortTime == "" {
                    cell.datePicker.date = Date()
                } else {
                    cell.datePicker.date = selectedTask.reminderLongTime
                }
                
                return cell
            }
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
            cell.textLabel?.text = weekdays[indexPath.row]
            cell.textLabel?.textColor = Colors.qDarkGrey
            cell.textLabel?.font = .systemFont(ofSize: 15)
            
            for day in selectedTask.repeatDays {
                if day == weekdays[indexPath.row]{
                    cell.accessoryType = .checkmark
                }
            }
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension EditTaskVC : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath == IndexPath(row: 0, section: 1) {
            return 200
        } else if indexPath == IndexPath(row: 2, section: 2) {
            return 150
        }
        
        return 50
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Notes"
        case 3:
            return "Repeating days"
        default:
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == IndexPath(row: 1, section: 2) {
            if numberOfReminderRows == 2 {
                numberOfReminderRows += 1
                tableView.insertRows(at: [IndexPath(row: numberOfReminderRows - 1, section: 2)], with: .automatic)
            } else if numberOfReminderRows == 3 {
                numberOfReminderRows -= 1
                tableView.deleteRows(at: [IndexPath(row: numberOfReminderRows, section: 2)], with: .automatic)
            }
        }
        
        if indexPath.section == 3 {
            let dayCell = tableView.cellForRow(at: indexPath)
            
            // change accessory type
            if dayCell?.accessoryType != .checkmark {
                dayCell?.accessoryType = .checkmark
                
                if !originalSelectedDays.contains((dayCell?.textLabel?.text!)!) {
                    originalSelectedDays.append((dayCell?.textLabel?.text!)!)
                }
            } else {
                dayCell?.accessoryType = .none
                
                if originalSelectedDays.contains((dayCell?.textLabel?.text!)!) {
                    for (i, day) in originalSelectedDays.enumerated() {
                        if day == dayCell?.textLabel?.text! {
                            originalSelectedDays.remove(at: i)
                        }
                    }
                }
            }
        }
    }
}

// -----------------------------------------
// MARK: TF Delegate
// -----------------------------------------

extension EditTaskVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Notes..." {
            textView.text = ""
            textView.font = .systemFont(ofSize: 15)
            textView.textColor = Colors.qDarkGrey
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Notes..."
            textView.textColor = .lightGray
            textView.font = .systemFont(ofSize: 15)
        }
    }
}

// -----------------------------------------
// MARK: Custom Delegates
// -----------------------------------------

extension EditTaskVC: TimeChangedDelegate {
    func updateTime(time: Date) {
        // assign the updated time to a global property 
        updatedReminderTime = time
        let timeCell = tableView.cellForRow(at: IndexPath(row: 1, section: 2))
        timeCell?.textLabel?.text = dayAndTimeFormatter.string(from: time)
    }
}
