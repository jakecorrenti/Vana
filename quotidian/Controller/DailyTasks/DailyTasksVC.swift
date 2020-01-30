//
//  DailyTasksVC.swift
//  quotidian
//
//  Created by Jake Correnti on 1/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class DailyTasksVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var tableView: UITableView = {
        let view             = UITableView()
        view.backgroundColor = Colors.qBG
        return view
    }()
    
    // -----------------------------------------
    // MARK: Life Cycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
       
        navigationItem.title = "Tasks"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Colors.qDarkGrey
        ]

        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor : Colors.qDarkGrey
        ]
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: Images.plus), style: .plain, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.backBarButtonItem  = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func setupUI() {
        view.addSubview(tableView)
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .zero, size: .zero)
    }
    
    @objc func addButtonPressed() {
        navigationController?.pushViewController(NewTaskVC(), animated: true)
    }
}
