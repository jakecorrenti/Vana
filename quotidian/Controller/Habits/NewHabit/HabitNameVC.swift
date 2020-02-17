//
//  HabitNameVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/15/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class HabitNameVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var header: UILabel = {
        let view           = UILabel()
        view.text          = "What's your bad habit?"
        view.textAlignment = .center
        view.textColor     = .black
        view.font          = UIFont.boldSystemFont(ofSize: 30)
        return view
    }()

    lazy var habitNameTextField: UITextField = {
        let view           = UITextField()
        view.font          = UIFont.boldSystemFont(ofSize: 30)
        view.textColor     = Colors.qDarkGrey
        view.placeholder   = "Enter habit name..."
        view.textAlignment = .center
        view.delegate      = self
        view.returnKeyType = .done
        view.addTarget(self, action: #selector(checkTextFieldContents), for: .editingChanged)
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
        view.backgroundColor             = Colors.qBG
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func setupUI() {
        [header, habitNameTextField, continueButton].forEach {view.addSubview($0)}
        
        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        
        habitNameTextField.anchor(top: nil, leading: view.leadingAnchor, bottom: view.centerYAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .zero)
        
        continueButton.anchor(top: nil, leading: nil, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 16, right: 16), size: .init(width: 60, height: 60))
    }
    
    func verifyHabitName() -> Bool {
        if habitNameTextField.text != nil && habitNameTextField.text != "" && habitNameTextField.text != " " {
            return true
        }
        return false
    }
    
    @objc func checkTextFieldContents() {
        if verifyHabitName() {
            continueButton.setActivatedState()
        } else {
            continueButton.setDeactivatedState()
        }
    }

    @objc func continueButtonPressed() {
        if verifyHabitName() {
            let cue       = HabitCueVC()
            cue.habitName = habitNameTextField.text!
            navigationController?.pushViewController(cue, animated: true)
        }
    }
}

extension HabitNameVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
