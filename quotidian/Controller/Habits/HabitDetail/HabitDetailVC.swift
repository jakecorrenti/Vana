//
// Created by Jake Correnti on 2/16/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class HabitDetailVC: UIViewController {

    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------

    var habit: Habit?

    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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