//
// Created by Jake Correnti on 2/16/20.
// Copyright (c) 2020 Jake Correnti. All rights reserved.
//

import UIKit

class HabitCell: UITableViewCell {

    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------

    lazy var bgView: UIView = {
        let view                 = UIView()
        view.backgroundColor     = UIColor(named: ColorNames.accessoryBGColor)
        view.layer.cornerRadius  = 12
        view.layer.masksToBounds = true
        return view
    }()

    lazy var habitNameLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Habit name"
        view.font      = UIFont.boldSystemFont(ofSize: 22)
        return view
    }()

    lazy var habitDailyProgressBar: UIProgressView = {
        let view                 = UIProgressView()
        view.progress            = 0
        view.progressTintColor   = Colors.qPurple
        view.backgroundColor     = UIColor(named: ColorNames.secondaryAccessoryBGColor)
        view.layer.cornerRadius  = 6
        view.layer.masksToBounds = true
        return view
    }()

    lazy var progressLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Today's progress:"
        view.font      = UIFont.systemFont(ofSize: 15)
        return view
    }()

    lazy var progressValueLabel: UILabel = {
        let view       = UILabel()
        view.text      = "50%"
        view.font      = UIFont.systemFont(ofSize: 18)
        view.textColor = Colors.qPurple
        return view
    }()

    lazy var routinesCompletedLabel: UILabel = {
        let view           = UILabel()
        view.text          = "Actions completed:"
        view.font          = UIFont.systemFont(ofSize: 15)
        view.textAlignment = .right
        return view
    }()

    lazy var routinesCompletedValueLabel: UILabel = {
        let view           = UILabel()
        view.text          = "3/6"
        view.font          = UIFont.systemFont(ofSize: 18)
        view.textColor     = Colors.qPurple
        view.textAlignment = .right
        return view
    }()

    lazy var progressVStack: UIStackView = {
        let view     = UIStackView(arrangedSubviews: [self.progressLabel, self.progressValueLabel])
        view.axis    = .vertical
        view.spacing = 7
        return view
    }()

    lazy var routinesVStack: UIStackView = {
        let view     = UIStackView(arrangedSubviews: [self.routinesCompletedLabel, self.routinesCompletedValueLabel])
        view.axis    = .vertical
        view.spacing = 7
        return view
    }()
    
    lazy var streakContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemRed
        return view
    }()
    
    lazy var streakCounterLabel: UILabel = {
        let view = UILabel()
        return view
    }()

    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        setupUI()
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupUI()
    }

    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------

    private func setupUI() {
        [bgView, habitNameLabel, habitDailyProgressBar, progressVStack, routinesVStack, streakContainerView].forEach {addSubview($0)}

        constrainBGView()
        constrainHabitNameLabel()
        constrainHabitDailyProgressBar()
        constrainProgressVStack()
        constrainRoutinesVStack()
        constrainStreakContainerView()
    }
    
    private func constrainBGView() {
        bgView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            bgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            bgView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            bgView.heightAnchor.constraint(equalToConstant: 175)
        ])
    }
    
    private func constrainHabitNameLabel() {
        habitNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitNameLabel.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 16),
            habitNameLabel.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16)
        ])
    }
    
    private func constrainHabitDailyProgressBar() {
        habitDailyProgressBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            habitDailyProgressBar.topAnchor.constraint(equalTo: habitNameLabel.bottomAnchor, constant: 22),
            habitDailyProgressBar.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            habitDailyProgressBar.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16),
            habitDailyProgressBar.heightAnchor.constraint(equalToConstant: 12)
        ])
    }
    
    private func constrainProgressVStack() {
        progressVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            progressVStack.topAnchor.constraint(equalTo: habitDailyProgressBar.bottomAnchor, constant: 22),
            progressVStack.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 16),
            progressVStack.trailingAnchor.constraint(equalTo: bgView.centerXAnchor, constant: -16),
            progressVStack.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -16)
        ])
    }
    
    private func constrainRoutinesVStack() {
        routinesVStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            routinesVStack.topAnchor.constraint(equalTo: habitDailyProgressBar.bottomAnchor, constant: 22),
            routinesVStack.leadingAnchor.constraint(equalTo: bgView.centerXAnchor, constant: 16),
            routinesVStack.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -16),
            routinesVStack.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: -16)
        ])
    }
    
    private func constrainStreakContainerView() {
        streakContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            streakContainerView.topAnchor.constraint(equalTo: bgView.bottomAnchor),
            streakContainerView.trailingAnchor.constraint(equalTo: bgView.trailingAnchor, constant: -12),
            streakContainerView.leadingAnchor.constraint(equalTo: bgView.centerXAnchor),
            streakContainerView.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func configure(habit: Habit) {
        habitNameLabel.text = habit.name
        
        var progress: Float = 0.0
        for action in habit.updatedRoutine where action.isCompleted {
            progress += 1
        }
        let percentage = progress / Float(habit.updatedRoutine.count)
        habitDailyProgressBar.setProgress(percentage, animated: false)
        
        progressValueLabel.text = "\(Int(percentage * 100))%"
        routinesCompletedValueLabel.text = "\(Int(progress))/\(habit.updatedRoutine.count)"
    }
    
    func setStreak(at streak: Int) {
        //TODO: -  write ui components
    }

}
