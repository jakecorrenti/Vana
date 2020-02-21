//
//  RoutineBarChartVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/17/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class RoutineBarChartVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    let realm = try! Realm()
    var habit: Habit?
    
    lazy var formatter: DateFormatter = {
        let f        = DateFormatter()
        f.dateFormat = "MM/dd/yyyy"
        return f
    }()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var barStackView: UIStackView = {
        let view          = UIStackView()
        view.distribution = .fillEqually
        view.spacing      = 4
        return view
    }()
    
    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupContainerView()
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    func setupUI() {
        
        [barStackView].forEach {view.addSubview($0)}
        
        barStackView.anchor(top: view.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 8), size: .zero)
    }
    
    func setupContainerView() {
        view.backgroundColor = Colors.qWhite
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
    }
    
    func configure(numberOfDays: Int) {
        let data = accessBarChartData(numberOfDays: numberOfDays)
        
        barStackView.arrangedSubviews.forEach { barStackView.removeArrangedSubview($0) }
        
        // negative value allows for the current day to be the last bar in the graph, otherwise, it would be the first
        ((-numberOfDays + 1)...0).forEach { day in
            
            let barBGView = UIView()
            barBGView.backgroundColor    = UIColor.init(white: 0.95, alpha: 1)
            barBGView.layer.cornerRadius = 4
            
            let barView = UIView()
            barView.backgroundColor    = Colors.qPurple
            barView.layer.cornerRadius = 4
            
            barBGView.addSubview(barView)
            
            let multiplier = data[-day]
            barView.anchor(top: nil, leading: barBGView.leadingAnchor, bottom: barBGView.bottomAnchor, trailing: barBGView.trailingAnchor, centerX: nil, centerY: nil)
            
            barView.heightAnchor.constraint(equalTo: barBGView.heightAnchor, multiplier: multiplier).isActive = true
            
            barStackView.addArrangedSubview(barBGView)
        }
        
    }
 
    func accessBarChartData(numberOfDays: Int) -> [CGFloat] {
        var dates            = [String]()
        var completedActions = [CGFloat]()
        
        for i in 0..<numberOfDays {
            dates.append(formatter.string(from: Calendar.current.date(byAdding: .day, value: -i, to: Date())!))
        }
        
        for date in dates {
            var completionNum = 0.0
            for action in realm.objects(RoutineAction.self) {
                for day in action.daysCompleted {
                    if day == date {
                        for routineAction in habit!.updatedRoutine {
                            // does check of uid to make sure that data from other routines is not being gathered
                            if routineAction.uid == action.uid {
                                completionNum += 1
                            }
                        }
                    }
                }
            }
            completedActions.append(CGFloat(completionNum) / CGFloat(habit!.updatedRoutine.count))
        }
        return completedActions
    }
}
