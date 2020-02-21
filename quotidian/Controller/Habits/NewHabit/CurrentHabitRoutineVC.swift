//
// Created by Jake Correnti on 2/15/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class CurrentHabitRoutineVC: UIViewController {

    // Properties

    var habitName: String?
    var habitCue : String?

    var actions = [String]()

    // Views

    lazy var header: UILabel = {
        let view           = UILabel()
        view.text          = "What's your current routine?"
        view.font          = UIFont.boldSystemFont(ofSize: 30)
        view.textColor     = .black
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()

    lazy var subheader: UILabel = {
        let view           = UILabel()
        view.text          = "The habitual action(s) following the cue."
        view.font          = UIFont.systemFont(ofSize: 18)
        view.textColor     = Colors.qDarkGrey
        view.textAlignment = .center
        view.numberOfLines = 0
        return view
    }()

    lazy var addActionButton: PurpleButton = {
        let view = PurpleButton(type: .system)
        view.configure(title: "Add action")
        view.setActivatedState()
        view.addTarget(self, action: #selector(addActionButtonPressed), for: .touchUpInside)
        return view
    }()

    lazy var actionsTableView: UITableView = {
        let view             = UITableView()
        view.delegate        = self
        view.dataSource      = self
        view.backgroundColor = Colors.qBG
        view.separatorStyle  = .none
        view.tableFooterView = UIView()
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        return view
    }()

    lazy var continueButton: PurpleButton = {
        let view = PurpleButton(type: .system)
        view.layer.cornerRadius = 30
        view.configure(title: "→")
        view.setDeactivatedState()
        view.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
        return view
    }()

    // Lifecycle

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tabBarController?.tabBar.isHidden = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        tabBarController?.tabBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupUI()
    }

    // Setup UI

    func setupNavBar() {
        view.backgroundColor             = Colors.qBG
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    func setupUI() {
        [header, subheader, addActionButton, actionsTableView, continueButton].forEach {view.addSubview($0)}

        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        subheader.anchor(top: header.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 36, left: 16, bottom: 0, right: 16))

        addActionButton.anchor(top: subheader.bottomAnchor, leading: nil, bottom: nil, trailing: nil, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 50, left: 0, bottom: 0, right: 0), size: .init(width: view.frame.width / 3, height: 40))
        actionsTableView.anchor(top: addActionButton.bottomAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 0))

        continueButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 60, height: 60))
    }

    func promptUserForSubTask() {
        let ac = UIAlertController(title: "Current routine action", message: nil, preferredStyle: .alert)
        ac.addTextField()

        let submitAction = UIAlertAction(title: "Done", style: .default) { [unowned ac] _ in
            let answer = ac.textFields![0]

            if answer.text != nil || answer.text != " " || !answer.text!.isEmpty {
                self.addTaskToTableView(name: answer.text!)
                self.isActionsListed()
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        ac.addAction(submitAction)
        ac.addAction(cancelAction)

        present(ac, animated: true)
    }

    func addTaskToTableView(name: String) {
        actions.append(name)

        actionsTableView.insertRows(at: [IndexPath(row: actions.count - 1, section: 0)], with: .automatic)
        actionsTableView.scrollToRow(at: IndexPath(row: actions.count - 1, section: 0), at: .bottom, animated: true)
    }

    func isActionsListed() {

        if actions.count == 0 {
            continueButton.setDeactivatedState()
        } else {
            continueButton.setActivatedState()
        }
    }

    func promptForActionDelete(indexPath: IndexPath) {
        let alertController = UIAlertController(title: "Would you like to delete \"\(actions[indexPath.row])\"?", message: nil, preferredStyle: .actionSheet)

        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { _ in
            self.actions.remove(at: indexPath.row)
            self.actionsTableView.deleteRows(at: [indexPath], with: .automatic)
            self.isActionsListed()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            self.isActionsListed()
        }

        [deleteAction, cancelAction].forEach {alertController.addAction($0)}
        present(alertController, animated: true)
    }
    
    func createActionsInstances() -> List<RoutineAction> {
        let routineActions = List<RoutineAction>()
        
        for action in actions {
            if action == "" || action == " " {
                continue
            } else {
                let routine = RoutineAction()
                routine.name = action
                
                routineActions.append(routine)
            }
        }
        
        return routineActions
    }

    @objc func addActionButtonPressed() {
        promptUserForSubTask()
    }
    
    @objc func continueButtonPressed() {
        let reward          = HabitRewardVC()
        reward.habitName    = habitName
        reward.habitCue     = habitCue
        reward.habitRoutine = createActionsInstances()
        self.navigationController?.pushViewController(reward, animated: true)
    }
}

extension CurrentHabitRoutineVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actions.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
        cell.textLabel?.text      = actions[indexPath.row]
        cell.textLabel?.font      = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = Colors.qDarkGrey
        cell.backgroundColor      = Colors.qBG
        cell.selectionStyle       = .none
        cell.imageView?.image     = UIImage(systemName: Images.completedCircle)
        return cell
    }
}

extension CurrentHabitRoutineVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        promptForActionDelete(indexPath: indexPath)
    }
}