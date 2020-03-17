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
    
    lazy var shorterFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "MMM d, yyyy"
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
        view.separatorStyle      = .none 
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
    
    lazy var dateRangeLabel: UILabel = {
        let view = UILabel()
        view.text = "3/3/2020 - 3/20/2020"
        view.font = .boldSystemFont(ofSize: 18)
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

    private func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationItem.title = habit!.name
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(editButtonPressed))
        navigationItem.rightBarButtonItem = editButton
    }

    private func setupUI() {
        view.addSubview(scrollView)
        
        addBarChartVC()
        updateDateRangeLabel(numberOfDays: 7)
        
        [completionHistoryLabel, timePeriodControl, dateRangeLabel, barChartVC.view, routineCueLabel, routineCueValueLabel, routineActionsLabel, actionsTableView, routineRewardLabel, routineRewardValueLabel, completeHabitButton, deleteHabitButton].forEach {scrollView.addSubview($0)}

        constrainScrollView()
        constrainCompletionHistoryLabel()
        constrainTimePeriodControl()
        constrainDateRangeLabel()
        constrainBarChart()
        constrainRoutineCueLabel()
        constrainRoutineCueValueLabel()
        constrainRoutineActionsLabel()
        constrainActionsTableView()
        constrainRoutineRewardLabel()
        constrainRoutineRewardValueLabel()
        constrainCompleteHabitButton()
        constrainDeleteHabitButton()
    }
    
    private func constrainScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func constrainCompletionHistoryLabel() {
        completionHistoryLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completionHistoryLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 24),
            completionHistoryLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            completionHistoryLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16)
        ])
    }
    
    private func constrainTimePeriodControl() {
        timePeriodControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePeriodControl.topAnchor.constraint(equalTo: completionHistoryLabel.bottomAnchor, constant: 22),
            timePeriodControl.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            timePeriodControl.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            timePeriodControl.widthAnchor.constraint(equalToConstant: view.frame.width - 32)
        ])
    }
    
    private func constrainDateRangeLabel() {
        dateRangeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            dateRangeLabel.topAnchor.constraint(equalTo: timePeriodControl.bottomAnchor, constant: 24),
            dateRangeLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            dateRangeLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16)
        ])
    }
    
    private func constrainBarChart() {
        barChartVC.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barChartVC.view.topAnchor.constraint(equalTo: dateRangeLabel.bottomAnchor, constant: 8),
            barChartVC.view.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            barChartVC.view.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            barChartVC.view.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    private func constrainRoutineCueLabel() {
        routineCueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            routineCueLabel.topAnchor.constraint(equalTo: barChartVC.view.bottomAnchor, constant: 50),
            routineCueLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            routineCueLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16)
        ])
    }
    
    private func constrainRoutineCueValueLabel() {
        routineCueValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            routineCueValueLabel.topAnchor.constraint(equalTo: routineCueLabel.bottomAnchor, constant: 22),
            routineCueValueLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            routineCueValueLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16)
        ])
    }
    
    private func constrainRoutineActionsLabel() {
        routineActionsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            routineActionsLabel.topAnchor.constraint(equalTo: routineCueValueLabel.bottomAnchor, constant: 50),
            routineActionsLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            routineActionsLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16)
        ])
    }
    
    private func constrainActionsTableView() {
        actionsTableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            actionsTableView.topAnchor.constraint(equalTo: routineActionsLabel.bottomAnchor, constant: 22),
            actionsTableView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            actionsTableView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            actionsTableView.heightAnchor.constraint(equalToConstant: CGFloat(habit!.updatedRoutine.count * 50))
        ])
    }

    
    private func constrainRoutineRewardLabel() {
        routineRewardLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            routineRewardLabel.topAnchor.constraint(equalTo: actionsTableView.bottomAnchor, constant: 50),
            routineRewardLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            routineRewardLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16)
        ])
    }
    
    private func constrainRoutineRewardValueLabel() {
        routineRewardValueLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            routineRewardValueLabel.topAnchor.constraint(equalTo: routineRewardLabel.bottomAnchor, constant: 22),
            routineRewardValueLabel.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            routineRewardValueLabel.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16)
        ])
    }
    
    private func constrainCompleteHabitButton() {
        completeHabitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            completeHabitButton.topAnchor.constraint(equalTo: routineRewardValueLabel.bottomAnchor, constant: 50),
            completeHabitButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            completeHabitButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            completeHabitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func constrainDeleteHabitButton() {
        deleteHabitButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            deleteHabitButton.topAnchor.constraint(equalTo: completeHabitButton.bottomAnchor, constant: 22),
            deleteHabitButton.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            deleteHabitButton.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 16),
            deleteHabitButton.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -16),
            deleteHabitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func populateHabitLabels() {
        routineCueValueLabel.text    = habit!.cue
        routineRewardValueLabel.text = habit!.reward
        
    }
    
    private func addBarChartVC() {
        scrollView.addSubview(barChartVC.view)
        self.addChild(barChartVC)
        barChartVC.didMove(toParent: self)
        
        barChartVC.configure(numberOfDays: 7)
        barChartVC.view.layer.cornerRadius = 12
    }
    
    private func updateDateRangeLabel(numberOfDays: Int) {
        let previousDate = shorterFormatter.string(from: Calendar.current.date(byAdding: .day, value: -numberOfDays, to: Date())!)
        let currentDate = shorterFormatter.string(from: Date())
        
        dateRangeLabel.text = "\(previousDate) - \(currentDate)"
    }
    
    @objc func historyValueChanged() {
        switch timePeriodControl.selectedSegmentIndex {
        case 0:
            barChartVC.configure(numberOfDays: 7)
            updateDateRangeLabel(numberOfDays: 7)
        case 1:
            barChartVC.configure(numberOfDays: 14)
            updateDateRangeLabel(numberOfDays: 14)
        case 2:
            barChartVC.configure(numberOfDays: 30)
            updateDateRangeLabel(numberOfDays: 30)
        case 3:
            barChartVC.configure(numberOfDays: 60)
            updateDateRangeLabel(numberOfDays: 60)
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
        
        // updates the bar value when routine actions are completed/un-completed
        historyValueChanged()
        
    }
}
