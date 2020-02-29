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
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: Images.plus), style: .plain, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
    }
    
    private func setupUI() {
        view.addSubview(tasksTableView)
        
        tasksTableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
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
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20)
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
