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
    
    lazy var greatestNumberInScaleLabel: UILabel = {
        let view = UILabel()
        view.text = "\(self.habit!.updatedRoutine.count)"
        view.textColor = Colors.qDarkGrey
        view.font = .systemFont(ofSize: 11)
        return view
    }()
    
    lazy var zeroLabel: UILabel = {
        let view = UILabel()
        view.text = "\(0)"
        view.textColor = Colors.qDarkGrey
        view.font = .systemFont(ofSize: 11)
        return view
    }()
    
    lazy var halfOfScaleLabel: UILabel = {
        let view = UILabel()
        view.text = "\(Int(self.habit!.updatedRoutine.count / 2))"
        view.textColor = Colors.qDarkGrey
        view.font = .systemFont(ofSize: 11)
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
        
        [greatestNumberInScaleLabel, barStackView, halfOfScaleLabel, zeroLabel].forEach {view.addSubview($0)}
        
        constrainGreatestNumberInScale()
        constrainBarStackView()
        constrainHalfOfScale()
        constrainZeroLabel()
    }
    
    private func constrainBarStackView() {
        barStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            barStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            barStackView.leadingAnchor.constraint(equalTo: greatestNumberInScaleLabel.trailingAnchor, constant: 4),
            barStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -8),
            barStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8)
        ])
    }
    
    private func constrainGreatestNumberInScale() {
        greatestNumberInScaleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            greatestNumberInScaleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 8),
            greatestNumberInScaleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4)
        ])
    }
    
    private func constrainHalfOfScale() {
        halfOfScaleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            halfOfScaleLabel.centerYAnchor.constraint(equalTo: barStackView.centerYAnchor),
            halfOfScaleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4)
        ])
    }
    
    private func constrainZeroLabel() {
        zeroLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            zeroLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 4),
            zeroLabel.bottomAnchor.constraint(equalTo: barStackView.bottomAnchor)
        ])
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
