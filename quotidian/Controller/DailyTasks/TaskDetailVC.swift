//
//  TaskDetailVC.swift
//  quotidian
//
//  Created by Jake Correnti on 1/31/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift
import UserNotifications

protocol TaskCompletedDelegate {
    func completionFor(status: Bool)
}

class TaskDetailVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var taskSelected = Task()
    var realm = try! Realm()
    
    var sectionNames: [String] = [
        "description",
        "days repeating",
        "reminder",
        "checklist items",
        "", // section for the complete task button && delete task button
    ]
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .grouped)
        view.dataSource         = self
        view.delegate           = self
        view.backgroundColor    = Colors.qBG
        view.rowHeight          = UITableView.automaticDimension
        view.estimatedRowHeight = 250
        view.separatorStyle     = .none
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        view.register(CompletionButtonCell.self, forCellReuseIdentifier: Cells.completionCell)
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
        view.backgroundColor = Colors.qBG
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .zero, size: .zero)
    }
    
    func accessDaysRepeatingFor(task: Task) -> String {
        
        var repeatDaysString = "No repeating days selected"
        
        if task.repeatDays.count > 0 {
            repeatDaysString = ""
            for (index, day) in task.repeatDays.enumerated() {
                repeatDaysString += day
                
                if index != task.repeatDays.count - 1 {
                    repeatDaysString += ", "
                }
            }
        }
        
        if checkEveryDayString(dayString: repeatDaysString) {
            repeatDaysString = "Everyday"
        }
        
        if checkWeekdaysString(dayString: repeatDaysString) {
            repeatDaysString = "Weekdays"
        }
        
        if checkWeekendDayString(dayString: repeatDaysString) {
            repeatDaysString = "Weekend"
        }
        
        return repeatDaysString
    }
    
    func checkWeekdaysString(dayString: String) -> Bool {
        
        if dayString == "Monday, Tuesday, Wednesday, Thursday, Friday" {
            return true
        }
        return false
    }
    
    func checkEveryDayString(dayString: String) -> Bool {
        if dayString == "Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday" {
            return true
        }
        return false
    }
    
    func checkWeekendDayString(dayString: String) -> Bool {
        if dayString == "Sunday, Saturday" {
            return true
        }
        return false
    }
    
    @objc func editButtonPressed() {
        let edit  = EditTaskVC()
        edit.task = taskSelected
        navigationController?.pushViewController(edit, animated: true)
    }
}

// -----------------------------------------
// MARK: Data Source
// -----------------------------------------

extension TaskDetailVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 3 {
            if taskSelected.checkListItems.count > 0 {
                return taskSelected.checkListItems.count
            }
            return 1
        } else if section == sectionNames.count - 1 {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font          = UIFont.systemFont(ofSize: 18)
            cell.backgroundColor          = Colors.qBG
            cell.selectionStyle           = .none
            
            if taskSelected.taskDescription != "" {
                cell.textLabel?.text      = taskSelected.taskDescription
                cell.textLabel?.textColor = .black
                cell.textLabel?.numberOfLines = 0
            } else {
                cell.textLabel?.text      = "No description provided"
                cell.textLabel?.textColor = .lightGray
            }
            
            return cell
            
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font          = UIFont.systemFont(ofSize: 18)
            cell.backgroundColor          = Colors.qBG
            cell.selectionStyle           = .none
            
            cell.textLabel?.text = accessDaysRepeatingFor(task: taskSelected)
            
            if accessDaysRepeatingFor(task: taskSelected) == "No repeating days selected" {
                cell.textLabel?.textColor = .lightGray
            } else {
                cell.textLabel?.textColor = .black
            }
            
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font          = UIFont.systemFont(ofSize: 18)
            cell.backgroundColor          = Colors.qBG
            cell.selectionStyle           = .none
            
            if taskSelected.reminderShortTime == "" {
                cell.textLabel?.text      = "No reminder set"
                cell.textLabel?.textColor = .lightGray
            } else {
                cell.textLabel?.text = taskSelected.reminderShortTime
            }
            return cell
            
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
            cell.textLabel?.font  = UIFont.systemFont(ofSize: 18)
            cell.selectionStyle   = .none
            cell.backgroundColor  = Colors.qBG
            
            if taskSelected.checkListItems.count == 0 {
                cell.textLabel?.text      = "No checklist created"
                cell.textLabel?.textColor = .lightGray
            } else {
                cell.textLabel?.text      = taskSelected.checkListItems[indexPath.row].name
                
                if taskSelected.checkListItems[indexPath.row].isCompleted {
                    cell.imageView?.image     = UIImage(systemName: Images.completedCircle)
                } else {
                    cell.imageView?.image     = UIImage(systemName: Images.circle)
                }
                
                cell.textLabel?.textColor = .black
            }
            
            return cell
            
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.completionCell, for: indexPath) as! CompletionButtonCell
            cell.backgroundColor = Colors.qBG
            cell.selectionStyle  = .none
            cell.delegate        = self
            
            if indexPath.row == 0 {
                cell.configure(title: "Complete task", backgroundColor: Colors.qCompleteGreen, titleColor: Colors.qWhite, buttonType: "complete")
            } else if indexPath.row == 1 {
                cell.configure(title: "Delete task", backgroundColor: Colors.qBG, titleColor: Colors.qDeleteRed, buttonType: "delete")
            }
            
            return cell
        default:
            return UITableViewCell()
        }

    }

}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension TaskDetailVC : UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return sectionNames.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionNames[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 4 {
            return 60
        }
        
        return 55
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            
            let checklistItem = realm.objects(CheckListItem.self).filter("uid == '\(taskSelected.checkListItems[indexPath.row].uid)'").first
            
            if  tableView.cellForRow(at: indexPath)?.imageView!.image == UIImage(systemName: Images.completedCircle) {
                tableView.cellForRow(at: indexPath)?.imageView!.image = UIImage(systemName: Images.circle)
                
                try! realm.write {
                    checklistItem?.isCompleted = false
                }
                
            } else {
                tableView.cellForRow(at: indexPath)?.imageView!.image = UIImage(systemName: Images.completedCircle)
                
                try! realm.write {
                    checklistItem?.isCompleted = true 
                }
            }
        }
    }
}

// -----------------------------------------
// MARK: Task Completed Delegate
// -----------------------------------------

extension TaskDetailVC: TaskCompletedDelegate {
    func completionFor(status: Bool) {
        print(status)
        
        let task = realm.objects(Task.self).filter("uid == '\(taskSelected.uid)'").first
        
        if status {
            // if the status is true, the user completed the task, update the database
            
            try! realm.write {
                task?.isCompleted     = true
                task?.completedDate = Date()
            }
            
            navigationController?.popViewController(animated: true)
            
        } else {
            // if the status is false, the user deleted the task, update the databse and remove from Realm altogether
            let alertController = UIAlertController(title: "", message: "Are you sure you would like to delete \"\(String(describing: task!.title))\"?", preferredStyle: .actionSheet)
            
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
                
                try! self.realm.write {
                    
                    for item in task!.checkListItems {
                        let checklistItem = self.realm.objects(CheckListItem.self).filter("uid == '\(item.uid)'").first
                        
                        self.realm.delete(checklistItem!)
                    }
                    
                    let center = UNUserNotificationCenter.current()
                    center.removePendingNotificationRequests(withIdentifiers: [task!.uid])
                    
                    self.realm.delete(task!)
                }
                
                self.navigationController?.popViewController(animated: true)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            [deleteAction, cancelAction].forEach {alertController.addAction($0)}
            
            present(alertController, animated: true, completion: nil)
            
        }
    }
}

