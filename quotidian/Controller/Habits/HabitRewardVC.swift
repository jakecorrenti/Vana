//
//  HabitRewardVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/16/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class HabitRewardVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var habitName   : String?
    var habitCue    : String?
    var habitRoutine: List<RoutineAction>?
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var header: UILabel = {
        let view           = UILabel()
        view.text          = "What's your reward?"
        view.font          = UIFont.boldSystemFont(ofSize: 30)
        view.textColor     = .black
        view.textAlignment = .center
        return view
    }()
    
    lazy var subheader: UILabel = {
        let view           = UILabel()
        view.text          = "The positive feeling that is delivered at the end of the routine."
        view.font          = UIFont.systemFont(ofSize: 18)
        view.textColor     = Colors.qDarkGrey
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()
    
    lazy var rewardTextField: UITextField = {
        let view           = UITextField()
        view.font          = UIFont.boldSystemFont(ofSize: 30)
        view.placeholder   = "Enter reward..."
        view.textColor     = Colors.qDarkGrey
        view.returnKeyType = .done
        view.textAlignment = .center
        view.delegate      = self
        view.addTarget(self, action: #selector(checkTextFieldContents), for: .editingChanged)
        return view
    }()
    
    lazy var continueButton: PurpleButton = {
        let view = PurpleButton(type: .system)
        view.layer.cornerRadius  = 30
        view.layer.masksToBounds = true
        view.setDeactivatedState()
        view.configure(title: "→")
        view.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)
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
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func setupUI() {
        [header, subheader, rewardTextField, continueButton].forEach {view.addSubview($0)}

        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        subheader.anchor(top: header.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 36, left: 16, bottom: 0, right: 16))
        rewardTextField.anchor(top: nil, leading: view.leadingAnchor, bottom: view.centerYAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        continueButton.anchor(top: nil, leading: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 16, right: 16), size: .init(width: 60, height: 60))
    }
    
    func verifyHabitReward() -> Bool {
        if rewardTextField.text != nil && rewardTextField.text != "" && rewardTextField.text != " " {
            return true
        }
        return false
    }

    @objc func checkTextFieldContents() {
        if verifyHabitReward() {
            continueButton.setActivatedState()
        } else {
            continueButton.setDeactivatedState()
        }
    }
    
    @objc func continueButtonPressed() {
        if verifyHabitReward() {
            let defaults = UserDefaults.standard

            if defaults.bool(forKey: "firstHabitAdded") {
                let newRoutine          = NewHabitRoutineVC()
                newRoutine.habitName    = habitName
                newRoutine.habitCue     = habitCue
                newRoutine.habitRoutine = habitRoutine
                newRoutine.habitReward  = rewardTextField.text
                self.navigationController?.pushViewController(newRoutine, animated: true)
            } else {
                let onboarding          = NewRoutineOnboardingVC()
                onboarding.habitName    = habitName
                onboarding.habitCue     = habitCue
                onboarding.habitRoutine = habitRoutine
                onboarding.habitReward  = rewardTextField.text
                self.navigationController?.pushViewController(onboarding, animated: true)
            }
        }
    }
}

extension HabitRewardVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
