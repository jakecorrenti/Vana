//
// Created by Jake Correnti on 2/15/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit

class HabitCueVC: UIViewController {

    // Properties

    var habitName: String?

    // Views

    lazy var header: UILabel = {
        let view           = UILabel()
        view.text          = "What's your cue?"
        view.font          = UIFont.boldSystemFont(ofSize: 30)
        view.textColor     = .black
        view.textAlignment = .center
        return view
    }()

    lazy var subheader: UILabel = {
        let view           = UILabel()
        view.text          = "The trigger that initiates a person to automatically carry out a habit."
        view.font          = UIFont.systemFont(ofSize: 18)
        view.textColor     = Colors.qDarkGrey
        view.numberOfLines = 0
        view.textAlignment = .center
        return view
    }()

    lazy var habitCueTextField: UITextField = {
        let view           = UITextField()
        view.font          = UIFont.boldSystemFont(ofSize: 30)
        view.placeholder   = "Enter cue..."
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

    // Initialization

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
        view.backgroundColor = Colors.qBG
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }

    func setupUI() {
        [header, subheader, habitCueTextField, continueButton].forEach {view.addSubview($0)}

        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        subheader.anchor(top: header.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: nil, padding: .init(top: 36, left: 16, bottom: 0, right: 16))
        habitCueTextField.anchor(top: nil, leading: view.leadingAnchor, bottom: view.centerYAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        continueButton.anchor(top: nil, leading: view.trailingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 16, right: 16), size: .init(width: 60, height: 60))
    }

    func verifyHabitCue() -> Bool {
        if habitCueTextField.text != nil && habitCueTextField.text != "" && habitCueTextField.text != " " {
            return true
        }
        return false
    }

    @objc func checkTextFieldContents() {
        if verifyHabitCue() {
            continueButton.setActivatedState()
        } else {
            continueButton.setDeactivatedState()
        }
    }

    @objc func continueButtonPressed() {
        if verifyHabitCue() {
            let routine       = CurrentHabitRoutineVC()
            routine.habitName = habitName
            routine.habitCue  = habitCueTextField.text
            navigationController?.pushViewController(routine, animated: true)
        }
    }

}

extension HabitCueVC: UITextFieldDelegate {
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
