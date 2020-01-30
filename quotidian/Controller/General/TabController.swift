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
        tasks.tabBarItem = UITabBarItem(title: "Tasks", image: UIImage(systemName: Images.checkMark), tag: 0)
        
        viewControllers = [tasks]
        
    }

}
