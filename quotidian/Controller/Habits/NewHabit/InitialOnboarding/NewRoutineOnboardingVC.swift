//
//  NewRoutineOnboardingVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/16/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class NewRoutineOnboardingVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var habitName   : String?
    var habitCue    : String?
    var habitRoutine: List<RoutineAction>?
    var habitReward : String?
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var header: UILabel = {
        let view           = UILabel()
        view.text          = "What's next?"
        view.font          = UIFont.boldSystemFont(ofSize: 30)
        view.textColor     = .black
        view.textAlignment = .center
        return view
    }()
    
    lazy var subheader: UILabel = {
        let view           = UILabel()
        view.font          = UIFont.systemFont(ofSize: 25)
        view.textColor     = Colors.qDarkGrey
        view.textAlignment = .center
        view.numberOfLines = 0
        view.text          = "In order to break your habit, you must create a new routine to use when you receive your cue."
        return view
    }()
    
    lazy var continueButton: PurpleButton = {
        let view = PurpleButton(type: .system)
        view.configure(title: "Continue")
        view.setActivatedState()
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
        [header, subheader, continueButton].forEach {view.addSubview($0)}
        
        header.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .zero)
        
        subheader.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: view.centerXAnchor, centerY: view.centerYAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .zero)
        
        continueButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 16, right: 16), size: .init(width: 0, height: 50))
    }
    
    @objc func continueButtonPressed() {
        let newRoutine          = NewHabitRoutineVC()
        newRoutine.habitName    = habitName
        newRoutine.habitCue     = habitCue
        newRoutine.habitRoutine = habitRoutine
        newRoutine.habitReward  = habitReward
        self.navigationController?.pushViewController(newRoutine, animated: true)
    }
}
