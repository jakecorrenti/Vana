//
//  TaskDetailVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/27/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class TaskDetailVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var selectedTask = Task()
    
    lazy var dayAndTimeFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "EEEE MMMM d, h:mm a"
        return f
    }()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.backgroundColor = Colors.qBG
        view.delegate = self
        view.rowHeight = UITableView.automaticDimension
        view.estimatedRowHeight = 50
        view.dataSource = self
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        view.register(TextFieldCell.self, forCellReuseIdentifier: Cells.textFieldCell)
        view.register(TextViewCell.self, forCellReuseIdentifier: Cells.textViewCell)
        return view
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        tableView.reloadData()
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
        navigationItem.title = "Task info"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let deleteButton = UIBarButtonItem(image: UIImage(systemName: Images.trashcan), style: .plain, target: self, action: #selector(deleteButtonPressed))
        deleteButton.tintColor = Colors.qDeleteRed
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItems = [deleteButton, editButton]
    }
    
    private func setupUI() {
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
    }
    
    private func deleteNotifications() {
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
    
    @objc func deleteButtonPressed() {
        let controller = UIAlertController(title: "Would you like to delete \(selectedTask.name)?", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (action: UIAlertAction) in
            let dbManager: StorageContext = RealmStorageContext()
            self.deleteNotifications()
            try? dbManager.delete(object: self.selectedTask)
            self.navigationController?.popViewController(animated: true)
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        [delete, cancel].forEach {controller.addAction($0)}
        present(controller, animated: true, completion: nil)
    }
    
    @objc func editButtonPressed() {
        let edit = EditTaskVC()
        edit.selectedTask = selectedTask
        if selectedTask.reminderShortTime != "" { edit.numberOfReminderRows = 2 }
        navigationController?.pushViewController(edit, animated: true)
    }
}

// -----------------------------------------
// MARK: Data Source
// -----------------------------------------

extension TaskDetailVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            cell.textField.text = selectedTask.name
            cell.textField.isEnabled = false
            cell.selectionStyle = .none
            cell.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return cell
        case 1:
            // assign the cell to be a text view cell
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textViewCell, for: indexPath) as! TextViewCell
            
            if selectedTask.notes == "" {
                cell.textView.text = "There are no notes for this task."
                cell.heightAnchor.constraint(equalToConstant: 50).isActive = true
            } else {
                cell.textView.text = selectedTask.notes
            }
    
            cell.textView.isEditable = false
            cell.textView.isScrollEnabled = false
            cell.selectionStyle = .none
            return cell
            
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            
            if selectedTask.reminderShortTime == "" {
                cell.textField.text = "There is no reminder set"
            } else {
                cell.textField.text = dayAndTimeFormatter.string(from: selectedTask.reminderLongTime)
            }
            cell.textField.isEnabled = false
            cell.selectionStyle = .none
            cell.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            var days = ""
            
            if selectedTask.repeatDays.count == 0 {
                days = "There are no repeating days selected"
            } else {
                for day in selectedTask.repeatDays {
                    if day == selectedTask.repeatDays.last {
                        days += "\(day)"
                    } else {
                        days += "\(day), "
                    }
                }
            }
            
            cell.textField.text = days
            cell.textField.isEnabled = false
            cell.selectionStyle = .none
            cell.heightAnchor.constraint(equalToConstant: 50).isActive = true
            return cell
        case 4:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            if selectedTask.isCompleted {
                cell.textField.text = "Completed"
                cell.textField.textColor = Colors.qCompleteGreen
            } else {
                cell.textField.text =  "Incomplete"
                cell.textField.textColor = Colors.qDeleteRed
            }
            cell.textField.isEnabled = false
            cell.selectionStyle = .none
            cell.heightAnchor.constraint(equalToConstant: 50).isActive = true
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
        return 5 
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Notes"
        case 2:
            return "Reminder"
        case 3:
            return "Repeating days"
        case 4:
            return "Completion status"
        default:
            return ""
        }
    }
}
