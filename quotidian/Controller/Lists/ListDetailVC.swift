//
//  ListDetailVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class ListDetailVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var selectedList = UserList()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var tasksTableView: UITableView = {
        let view = UITableView()
        view.backgroundColor = Colors.qBG
        view.delegate = self
        view.dataSource = self
        view.tableFooterView = UIView()
        view.separatorStyle = .none
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        return view
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tasksTableView.reloadData()
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.navigationBar.tintColor = Colors.qPurple
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
        navigationItem.title = selectedList.name
        
        let moreButton = UIBarButtonItem(image: UIImage(systemName: Images.more), style: .plain, target: self, action: #selector(moreButtonPressed))
        let addButton = UIBarButtonItem(image: UIImage(systemName: Images.plus), style: .plain, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItems = [addButton, moreButton]
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
    }
    
    private func setupUI() {
        view.addSubview(tasksTableView)
        
        tasksTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
    }
    
    private func deleteAllListPendingNotifications() {
        var ids = [String]()
        
        for task in selectedList.tasks {
            for notification in task.notificationID {
                ids.append(notification)
            }
        }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ids)
    }
    
    private func deleteAllListTasks() {
        let dbManager: StorageContext = RealmStorageContext()
        
        for task in selectedList.tasks {
            try? dbManager.delete(object: task)
        }
    }
    
    private func deleteList() {
        let dbManager: StorageContext = RealmStorageContext()
        
        // delete the notifications that each task has within the list
        deleteAllListPendingNotifications()
        // delete the tasks within the list
        deleteAllListTasks()
        // delete the list
        try? dbManager.delete(object: selectedList)
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func moreButtonPressed() {
        let controller = UIAlertController(title: "Would you like to edit or delete \(selectedList.name)?", message: nil, preferredStyle: .actionSheet)
        let edit = UIAlertAction(title: "Edit", style: .default) { (alert) in
            // edit action
            let edit = EditListVC()
            edit.selectedList = self.selectedList
            self.navigationController?.pushViewController(edit, animated: true)
        }
        let delete = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
            // delete action
            self.deleteList()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        [edit, delete, cancel].forEach { controller.addAction($0) }
        present(controller, animated: true, completion: nil)
    }
    
    @objc func addButtonPressed() {
        let newTask = NewTaskVC()
        newTask.selectedList = selectedList
        navigationController?.pushViewController(newTask, animated: true)
    }
}

// -----------------------------------------
// MARK: Data Source
// -----------------------------------------

extension ListDetailVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedList.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
        cell.textLabel?.text = selectedList.tasks[indexPath.row].name
        cell.textLabel?.textColor = .black
        cell.textLabel?.font = .systemFont(ofSize: 20)
        cell.accessoryType = .detailButton
        cell.backgroundColor = Colors.qBG
        cell.selectionStyle = .none
        
        if selectedList.tasks[indexPath.row].isCompleted {
            cell.imageView?.image = UIImage(systemName: Images.completedCircle)
        } else {
            cell.imageView?.image = UIImage(systemName: Images.circle)
        }
        
        return cell
    }
}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension ListDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        print("tapped: \(indexPath.row)")
        
        // push to the task detail view where the user can edit and delete a task
        let detail = TaskDetailVC()
        detail.selectedTask = selectedList.tasks[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // handle cell completion circle and handle the databse as well
        
        let cell = tableView.cellForRow(at: indexPath)
        
        if cell?.imageView?.image == UIImage(systemName: Images.circle) {
            cell?.imageView?.image = UIImage(systemName: Images.completedCircle)
            
            let task = selectedList.tasks[indexPath.row]
            try? task.updateCompletion(with: true)
        } else {
            cell?.imageView?.image = UIImage(systemName: Images.circle)
            
            let task = selectedList.tasks[indexPath.row]
            try? task.updateCompletion(with: false)
        }
        
    }
}
