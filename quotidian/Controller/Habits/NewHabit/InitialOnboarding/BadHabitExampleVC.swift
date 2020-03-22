//
//  BadHabitExampleVC.swift
//  Vana
//
//  Created by Jake Correnti on 3/21/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class BadHabitExampleVC: UIViewController {
    
    // -----------------------------------------
    // MARK:  Views
    // -----------------------------------------
    
    let introComponent = ExampleIntroTextComponent()
    let scrollView     = UIScrollView()
    let nameExampleComponent = NameExampleComponent()
    let cueExampleComponent = CueExampleComponent()
    let routineExampleComponent = RoutineExampleComponent()
    let rewardExampleComponent = RewardExampleComponent()
    
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
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.bgColor)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    private func setupUI() {
        [continueButton, scrollView].forEach {view.addSubview($0)}
        [introComponent, nameExampleComponent, cueExampleComponent, routineExampleComponent, rewardExampleComponent].forEach {scrollView.addSubview($0)}
        
        constrainScrollView()
        constrainIntroComponent()
        constrainNameExampleComponent()
        constrainCueExampleComponent()
        constrainRoutineExampleComponent()
        constrainRewardExampleComponent()
        constrainContinueButton()
    }
    
    private func constrainIntroComponent() {
        introComponent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            introComponent.topAnchor.constraint(equalTo: scrollView.topAnchor),
            introComponent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            introComponent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            introComponent.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    private func constrainScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: continueButton.topAnchor)
        ])
    }
    
    private func constrainNameExampleComponent() {
        nameExampleComponent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameExampleComponent.topAnchor.constraint(equalTo: introComponent.subtitleLabel.bottomAnchor, constant: 50),
            nameExampleComponent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            nameExampleComponent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            nameExampleComponent.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    private func constrainCueExampleComponent() {
        cueExampleComponent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cueExampleComponent.topAnchor.constraint(equalTo: nameExampleComponent.vStack.bottomAnchor),
            cueExampleComponent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            cueExampleComponent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            cueExampleComponent.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    private func constrainRoutineExampleComponent() {
        routineExampleComponent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            routineExampleComponent.topAnchor.constraint(equalTo: cueExampleComponent.vStack.bottomAnchor),
            routineExampleComponent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            routineExampleComponent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            routineExampleComponent.widthAnchor.constraint(equalToConstant: view.frame.width)
        ])
    }
    
    private func constrainRewardExampleComponent() {
        rewardExampleComponent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rewardExampleComponent.topAnchor.constraint(equalTo: routineExampleComponent.vStack.bottomAnchor),
            rewardExampleComponent.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            rewardExampleComponent.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            rewardExampleComponent.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    private func constrainContinueButton() {
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            continueButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func continueButtonPressed() {
        navigationController?.pushViewController(HabitNameVC(), animated: true)
    }
}
