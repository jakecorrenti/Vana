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
    // MARK: Properties
    // -----------------------------------------
    
    private let routineManager = RoutineManager()

    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------

    lazy var tableView: UITableView = {
        let view             = UITableView()
        view.backgroundColor = UIColor(named: ColorNames.bgColor)
        view.delegate        = self
        view.dataSource      = self
        view.tableFooterView = UIView()
        view.separatorStyle  = .none
        view.register(HabitCell.self, forCellReuseIdentifier: Cells.habitCell)
        return view
    }()
    
    lazy var emptyStateView = HabitListEmptyState()

    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()
        tabBarController?.tabBar.isHidden = false
        
        checkIfHabitsHaveBeenCreated()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
    }

    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func checkIfHabitsHaveBeenCreated() {
        let realm = try! Realm()
        let habits = realm.objects(Habit.self).filter("isCompleted == false")
        if habits.count == 0 {
            setupTableViewEmptyStateUI()
        } else {
            setupUI()
        }
    }
    
    private func setupTableViewEmptyStateUI() {
        view.addSubview(emptyStateView)
        emptyStateView.createHabitButton.addTarget(self, action: #selector(addButtonPressed), for: .touchUpInside)
        emptyStateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emptyStateView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateView.widthAnchor.constraint(equalToConstant: view.frame.width * 0.75)
        ])
    }
    
    func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.bgColor)
        navigationItem.title = "My habits"
        navigationController?.navigationBar.prefersLargeTitles = true

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton 
        navigationItem.backBarButtonItem  = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
    }

    func accessHabits() -> Results<Habit> {
        let realm = try! Realm()
        return realm.objects(Habit.self).filter("isCompleted == false")
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

// -----------------------------------------
// MARK: Data Source
// -----------------------------------------

extension MyHabitsVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accessHabits().count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.habitCell, for: indexPath) as! HabitCell
        cell.backgroundColor = UIColor(named: ColorNames.bgColor)
        cell.selectionStyle  = .none
        cell.configure(habit: accessHabits()[indexPath.row])
        
        routineManager.habit = accessHabits()[indexPath.row]
        cell.setStreak(at: routineManager.getCurrentHabitCompletionStreak())
        return cell
    }

}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension MyHabitsVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 175
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detail = HabitDetailVC()
        detail.habit = accessHabits()[indexPath.row]
        detail.barChartVC.habit = accessHabits()[indexPath.row]
        navigationController?.pushViewController(detail, animated: true)
    }
}
