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

    func setupUI() {
        [bgView, habitNameLabel, habitDailyProgressBar, progressVStack, routinesVStack].forEach {addSubview($0)}

        bgView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 16))
        habitNameLabel.anchor(top: bgView.topAnchor, leading: bgView.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 0))
        habitDailyProgressBar.anchor(top: habitNameLabel.bottomAnchor, leading: bgView.leadingAnchor, bottom: nil, trailing: bgView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 22, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 12))
        progressVStack.anchor(top: habitDailyProgressBar.bottomAnchor, leading: bgView.leadingAnchor, bottom: bgView.bottomAnchor, trailing: bgView.centerXAnchor, centerX: nil, centerY: nil, padding: .init(top: 22, left: 16, bottom: 16, right: 16))
        routinesVStack.anchor(top: habitDailyProgressBar.bottomAnchor, leading: bgView.centerXAnchor, bottom: bgView.bottomAnchor, trailing: bgView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 22, left: 16, bottom: 16, right: 16))
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

}
