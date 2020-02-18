//
//  BarChartDetailVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/18/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class BarChartDetailVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var habit: Habit? 
    var dayRangeSelected: Int? 
    
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
    }
    
    func setupUI() {
        
    }
}
