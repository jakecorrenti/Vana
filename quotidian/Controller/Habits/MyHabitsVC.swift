//
//  MyHabitsVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/7/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class MyHabitsVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
    }

    
    // -----------------------------------------
    // MARK: View configuration and interaction
    // -----------------------------------------
    
    func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationItem.title = "My habits"
        navigationController?.navigationBar.prefersLargeTitles = true

        
        let addButton = UIBarButtonItem(image: UIImage(systemName: Images.plus), style: .plain, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton 
        navigationItem.backBarButtonItem  = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func setupUI() {

    }
    
    @objc func addButtonPressed() {
        let defaults = UserDefaults.standard
        
        if defaults.bool(forKey: "firstHabitAdded") {
            self.navigationController?.pushViewController(HabitNameVC(), animated: true)
        } else {
            self.navigationController?.pushViewController(BreakBadHabitsVC(), animated: true)
        }
    }
}
