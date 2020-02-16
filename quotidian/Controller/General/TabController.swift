//
//  TabController.swift
//  quotidian
//
//  Created by Jake Correnti on 1/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let tasks        = UINavigationController(rootViewController: DailyTasksVC())
        tasks.tabBarItem = UITabBarItem(title: "Tasks", image: UIImage.init(systemName: Images.checkMark, withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), tag: 0)
        
        let habits        = UINavigationController(rootViewController: MyHabitsVC())
        habits.tabBarItem = UITabBarItem(title: "Habits", image: UIImage.init(systemName: Images.timelapse, withConfiguration: UIImage.SymbolConfiguration(weight: .semibold)), tag: 1)
        
        viewControllers = [tasks, habits]
        
        tabBar.tintColor = .black 
        
    }

}
