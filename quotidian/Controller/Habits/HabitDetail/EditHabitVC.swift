//
//  EditHabitVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/19/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class EditHabitVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var habit = Habit()
    let realm = try! Realm()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var tableView: UITableView = {
        let view             = UITableView(frame: .zero, style: .insetGrouped)
        view.delegate        = self
        view.dataSource      = self
        view.backgroundColor = Colors.qBG
        view.keyboardDismissMode = .onDrag
        view.register(TextFieldCell.self, forCellReuseIdentifier: Cells.textFieldCell)
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
        registerKeyboardNotifications()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationItem.title = "Edit habit"
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func setupUI() {
        view.addSubview(tableView)
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil)
    }
    
    func registerKeyboardNotifications() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }

    func compareTitles() {
        let titleCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as! TextFieldCell
        
        if isTextFieldValid(cell: titleCell) {
            let title = titleCell.textField.text!
            
            if title != habit.name {
                try! realm.write {
                    let object = realm.objects(Habit.self).filter("uid == '\(habit.uid)'").first
                    object?.name = title
                }
            }
        } else {
            showMissingInformationAlert(title: "title")
        }
    }
    
    func compareCues() {
        let cueCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as! TextFieldCell
        
        if isTextFieldValid(cell: cueCell) {
            let cue = cueCell.textField.text!
            
            if cue != habit.cue {
                try! realm.write {
                    let object  = realm.objects(Habit.self).filter("uid == '\(habit.uid)'").first
                    object?.cue = cue
                }
            }
        } else {
            showMissingInformationAlert(title: "cue")
        }
    }
    
    func getRoutineCells() -> [String] {
        var actions = [String]()
        
        for (i, _) in habit.updatedRoutine.enumerated() {
            let textCell = tableView.cellForRow(at: IndexPath(row: i, section: 2)) as! TextFieldCell
            let name = textCell.textField.text
            
            if name != nil {
                actions.append(name!)
            }
        }
        return actions
    }
    
    func compareRoutineActions() {
        let newActions      = getRoutineCells()
        let originalActions = habit.updatedRoutine
        
        for (i, oldAction) in originalActions.enumerated() {
            print(oldAction.name, newActions[i])
            
            // check if the two are different then update realm file
            if newActions[i] == "" || newActions[i] == " " {
                try! realm.write {
                    let object = realm.objects(RoutineAction.self).filter("uid == '\(oldAction.uid)'").first
                    realm.delete(object!)
                }
            } else if oldAction.name != newActions[i] {
                let oldObject = realm.objects(RoutineAction.self).filter("uid == '\(oldAction.uid)'").first
                try! realm.write {
                    oldObject?.name = newActions[i]
                }
            }
        }
    }

    func compareRewards() {
        let rewardCell = tableView.cellForRow(at: IndexPath(row: 0, section: 3)) as! TextFieldCell
        if isTextFieldValid(cell: rewardCell) {
            let reward = rewardCell.textField.text!
            
            if reward != habit.reward {
                try! realm.write {
                    let object = realm.objects(Habit.self).filter("uid == '\(habit.uid)'").first
                    object?.reward = reward
                }
            }
        } else {
            showMissingInformationAlert(title: "reward")
        }
    }
    
    func isTextFieldValid<T>(cell: T) -> Bool {
        guard let cell = cell as? TextFieldCell else { return false }
        let text = cell.textField.text
        
        if text == "" || text == " " || text == nil {
            return false
        }
        
        return true
    }
    
    func showMissingInformationAlert(title: String) {
        let controller = UIAlertController(title: "You must enter a \(title.lowercased()) in order to make your edits", message: nil, preferredStyle: .alert)
        let action     = UIAlertAction(title: "Ok", style: .default, handler: nil)
        controller.addAction(action)
        present(controller, animated: true, completion: nil)
    }
    
    @objc func doneButtonPressed() {
        compareRewards()
        compareRoutineActions()
        compareCues()
        compareTitles()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}

// -----------------------------------------
// MARK: Datasource
// -----------------------------------------

extension EditHabitVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 2 {
            return habit.updatedRoutine.count
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            cell.configure(placeholder: "Enter habit name...")
            cell.textField.text = habit.name
            cell.textField.textColor = .black
            cell.selectionStyle = .none
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            cell.configure(placeholder: "Enter habit cue...")
            cell.textField.text = habit.cue
            cell.textField.textColor = .black
            cell.selectionStyle = .none
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            cell.configure(placeholder: "Enter rouine action...")
            cell.textField.text = habit.updatedRoutine[indexPath.row].name
            cell.textField.textColor = .black
            cell.selectionStyle = .none
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: Cells.textFieldCell, for: indexPath) as! TextFieldCell
            cell.configure(placeholder: "Enter habit reward...")
            cell.textField.text = habit.reward
            cell.selectionStyle = .none
            cell.textField.textColor = .black
            return cell
        default:
            return UITableViewCell()
        }
    }
}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension EditHabitVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Name"
        case 1:
            return "Cue"
        case 2:
            return "Routine"
        case 3:
            return "Reward"
        default:
            return ""
        }
    }
}
