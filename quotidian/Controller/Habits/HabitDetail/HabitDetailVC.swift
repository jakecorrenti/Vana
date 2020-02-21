//
// Created by Jake Correnti on 2/16/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class HabitDetailVC: UIViewController {

    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------

    var habit      : Habit?
    let realm      = try! Realm()
    let barChartVC = RoutineBarChartVC()
    
    lazy var formatter: DateFormatter = {
        let f        = DateFormatter()
        f.dateFormat = "MM/dd/yyyy"
        return f
    }()

    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------

    let scrollView = UIScrollView()

    lazy var completionHistoryLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Routine completion history: "
        view.font      = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = .black
        return view
    }()

    lazy var timePeriodControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["7d", "14d", "30d", "60d"])
        view.selectedSegmentIndex = 0
        view.addTarget(self, action: #selector(historyValueChanged), for: .valueChanged)
        return view
    }()
    
    lazy var routineCueLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Habit cue: "
        view.font      = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = .black
        return view
    }()
    
    lazy var routineCueValueLabel: UILabel = {
        let view       = UILabel()
        view.font      = UIFont.systemFont(ofSize: 18)
        view.textColor = .black
        return view
    }()
    
    lazy var routineActionsLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Routine actions: "
        view.font      = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = .black
        return view
    }()
    
    lazy var actionsTableView: UITableView = {
        let view                 = UITableView()
        view.dataSource          = self
        view.delegate            = self
        view.isScrollEnabled     = false
        view.layer.cornerRadius  = 12
        view.layer.masksToBounds = true
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        return view
    }()
    
    lazy var routineRewardLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Habit reward: "
        view.font      = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = .black
        return view
    }()
    
    lazy var routineRewardValueLabel: UILabel = {
        let view       = UILabel()
        view.font      = UIFont.systemFont(ofSize: 18)
        view.textColor = .black
        return view
    }()
    
    lazy var completeHabitButton: UIButton = {
        let view                 = UIButton(type: .system)
        view.backgroundColor     = Colors.qCompleteGreen
        view.layer.cornerRadius  = 12
        view.layer.masksToBounds = true
        view.titleLabel?.font    = UIFont.boldSystemFont(ofSize: 18)
        view.setTitle("Complete habit", for: .normal)
        view.setTitleColor(Colors.qWhite, for: .normal)
        view.addTarget(self, action: #selector(completeHabitButtonPressed), for: .touchUpInside)
        return view
    }()
    
    lazy var deleteHabitButton: UIButton = {
        let view              = UIButton(type: .system)
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.setTitle("Delete habit", for: .normal)
        view.setTitleColor(Colors.qDeleteRed, for: .normal)
        view.addTarget(self, action: #selector(deletHabitButtonPressed), for: .touchUpInside)
        return view
    }()

    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
        actionsTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupUI()
        populateHabitLabels()
    }

    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------

    func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationItem.title = habit!.name
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }

    func setupUI() {
        view.addSubview(scrollView)
        
        addBarChartVC()
        
        
        [completionHistoryLabel, timePeriodControl, barChartVC.view, routineCueLabel, routineCueValueLabel, routineActionsLabel, actionsTableView, routineRewardLabel, routineRewardValueLabel, completeHabitButton, deleteHabitButton].forEach {scrollView.addSubview($0)}

        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)

        completionHistoryLabel.anchor(top: scrollView.topAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 24, left: 16, bottom: 0, right: 16))
        timePeriodControl.anchor(top: completionHistoryLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 22, left: 16, bottom: 0, right: 16), size: .init(width: view.frame.width - 32, height: 0))
        barChartVC.view.anchor(top: timePeriodControl.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 22, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 200))
        
        routineCueLabel.anchor(top: barChartVC.view.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 50, left: 16, bottom: 0, right: 16))
        routineCueValueLabel.anchor(top: routineCueLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 22, left: 16, bottom: 0, right: 16))
        
        routineActionsLabel.anchor(top: routineCueValueLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 50, left: 16, bottom: 0, right: 16))
        actionsTableView.anchor(top: routineActionsLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 22, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: habit!.updatedRoutine.count * 50))
        
        routineRewardLabel.anchor(top: actionsTableView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 50, left: 16, bottom: 0, right: 16))
        routineRewardValueLabel.anchor(top: routineRewardLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 22, left: 16, bottom: 0, right: 16))
        
        completeHabitButton.anchor(top: routineRewardValueLabel.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 50, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 50))
        deleteHabitButton.anchor(top: completeHabitButton.bottomAnchor, leading: scrollView.leadingAnchor, bottom: scrollView.bottomAnchor, trailing: scrollView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 22, left: 16, bottom: 16, right: 16), size: .zero)
        
    }
    
    func populateHabitLabels() {
        routineCueValueLabel.text    = habit!.cue
        routineRewardValueLabel.text = habit!.reward
        
    }
    
    func addBarChartVC() {
        scrollView.addSubview(barChartVC.view)
        self.addChild(barChartVC)
        barChartVC.didMove(toParent: self)
        
        barChartVC.configure(numberOfDays: 7)
        barChartVC.view.layer.cornerRadius = 12
    }
    
    @objc func historyValueChanged() {
        switch timePeriodControl.selectedSegmentIndex {
        case 0:
            barChartVC.configure(numberOfDays: 7)
        case 1:
            barChartVC.configure(numberOfDays: 14)
        case 2:
            barChartVC.configure(numberOfDays: 30)
        case 3:
            barChartVC.configure(numberOfDays: 60)
        default:
            print("The index selected does not exist")
        }
    }
    
    @objc func completeHabitButtonPressed() {
        try! realm.write {
            let object            = realm.objects(Habit.self).filter("uid == '\(habit!.uid)'").first
            object?.isCompleted   = true
            object?.completedDate = formatter.string(from: Date())
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func deletHabitButtonPressed() {
        
        let controller = UIAlertController(title: "Are you sure you would like to delete \"\(habit!.name)\"?", message: nil, preferredStyle: .actionSheet)
        
        let delete = UIAlertAction(title: "Delete", style: .destructive) { _ in
            
            try! self.realm.write {
                
                self.habit!.originalRoutine.forEach { self.realm.delete(self.realm.objects(RoutineAction.self).filter("uid =='\($0.uid)'").first!) }
                self.habit!.updatedRoutine.forEach { self.realm.delete(self.realm.objects(RoutineAction.self).filter("uid =='\($0.uid)'").first!) }
                self.realm.delete(self.realm.objects(Habit.self).filter("uid == '\(self.habit!.uid)'").first!)
                self.navigationController?.popViewController(animated: true)

            }
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        [delete, cancel].forEach {controller.addAction($0)}
        present(controller, animated: true, completion: nil)
    }
    
    @objc func editButtonPressed() {
        let edit   = EditHabitVC()
        edit.habit = habit!
        navigationController?.pushViewController(edit, animated: true)
    }
}

// -----------------------------------------
// MARK: Datasource
// -----------------------------------------

extension HabitDetailVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habit!.updatedRoutine.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell             = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
        cell.textLabel?.text = habit!.updatedRoutine[indexPath.row].name
        cell.selectionStyle  = .none
        
        if habit!.updatedRoutine[indexPath.row].completedDate != formatter.string(from: Date()) {
            try! realm.write {
                
                let routine            = realm.objects(RoutineAction.self).filter("uid == '\(habit!.updatedRoutine[indexPath.row].uid)'").first
                routine?.completedDate = ""
                routine?.isCompleted   = false 
            }
        }
        
        if habit!.updatedRoutine[indexPath.row].isCompleted {
            print("Completed")
            cell.imageView?.image = UIImage(systemName: Images.completedCircle)
        } else {
            print("Not completed")
            cell.imageView?.image = UIImage(systemName: Images.circle)
        }
        
        return cell
    }
        
}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------
extension HabitDetailVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        
        let routine = habit!.updatedRoutine[indexPath.row]
        
        if routine.isCompleted {
            try! realm.write {
                routine.isCompleted = false
                
                for (i, day) in routine.daysCompleted.enumerated() {
                    if day == routine.completedDate {
                        routine.daysCompleted.remove(at: i)
                    }
                }
                
                routine.completedDate  = ""
                cell?.imageView?.image = UIImage(systemName: Images.circle)
                
            }
        } else {
            cell?.imageView?.image = UIImage(systemName: Images.completedCircle)
            
            try! realm.write {
                routine.isCompleted   = true
                routine.completedDate = formatter.string(from: Date())
                routine.daysCompleted.append(formatter.string(from: Date()))
                cell?.imageView?.image = UIImage(systemName: Images.completedCircle)
            }
        }
    }
}
