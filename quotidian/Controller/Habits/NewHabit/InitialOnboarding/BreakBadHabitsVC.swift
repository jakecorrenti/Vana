//
//  BreakBadHabitsVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/11/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class BreakBadHabitsVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var introText: BreakBadHabitsIntroText = {
        let view = BreakBadHabitsIntroText()
        return view
    }()
    
    lazy var threeHabitPartsText: ThreeHabitPartsDescText = {
        let view = ThreeHabitPartsDescText()
        return view
    }()
    
    lazy var continueButton: PurpleButton = {
        let view = PurpleButton(type: .system)
        view.configure(title: "Continue")
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
        [introText, threeHabitPartsText, continueButton].forEach {view.addSubview($0)}
        
        introText.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .zero)
        
        threeHabitPartsText.anchor(top: introText.subheader.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 50, left: 16, bottom: 0, right: 16), size: .zero)
        
        continueButton.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 16, right: 16), size: .init(width: 0, height: 50))
    }
    
    @objc func continueButtonPressed() {
        navigationController?.pushViewController(HabitNameVC(), animated: true)
    }
}
