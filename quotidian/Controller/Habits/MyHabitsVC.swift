//
//  MyHabitsVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/7/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class MyHabitsVC: UIViewController {

    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------

    lazy var tableView: UITableView = {
        let view             = UITableView()
        view.backgroundColor = Colors.qBG
        view.delegate        = self
        view.dataSource      = self
        view.tableFooterView = UIView()
        view.separatorStyle  = .none
        view.register(HabitCell.self, forCellReuseIdentifier: Cells.habitCell)
        return view
    }()

    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
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
        navigationItem.title = "My habits"
        navigationController?.navigationBar.prefersLargeTitles = true

        
        let addButton = UIBarButtonItem(image: UIImage(systemName: Images.plus), style: .plain, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton 
        navigationItem.backBarButtonItem  = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func setupUI() {
        view.addSubview(tableView)

        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
    }

    func accessHabits() -> Results<Habit> {
        let realm = try! Realm()
        return realm.objects(Habit.self)
    }
    
    @objc func addButtonPressed() {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "firstHabitAdded") {
            self.navigationController?.pushViewController(HabitNameVC(), animated: true)
        } else {
            self.navigationController?.pushViewController(BreakBadHabitsVC(), animated: true)
        }
    }
}

extension MyHabitsVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessHabits().count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.habitCell, for: indexPath) as! HabitCell
        cell.backgroundColor = Colors.qBG
        cell.selectionStyle  = .none
        cell.configure(habit: accessHabits()[indexPath.row])
        return cell
    }

}

extension MyHabitsVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = HabitDetailVC()
        detail.habit = accessHabits()[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }
}
