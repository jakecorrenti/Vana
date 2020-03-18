//
//  ThreeHabitPartsDescText.swift
//  quotidian
//
//  Created by Jake Correnti on 2/12/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class ThreeHabitPartsDescText: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var cueTitleLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Cue: "
        view.font      = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    lazy var cueContentLabel: UILabel = {
        let view           = UILabel()
        view.font          = UIFont.systemFont(ofSize: 18)
        view.textColor     = Colors.qDarkGrey
        view.numberOfLines = 0
        view.text          = "Trigger that initiates a person to automatically carry out a habit "
        return view
    }()
    
    lazy var cueVStack: UIStackView = {
        let view     = UIStackView(arrangedSubviews: [self.cueTitleLabel, self.cueContentLabel])
        view.axis    = .vertical
        view.spacing = 16
        return view
    }()
    
    lazy var routineTitleLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Routine: "
        view.font      = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    lazy var routineContentLabel: UILabel = {
        let view           = UILabel()
        view.font          = UIFont.systemFont(ofSize: 18)
        view.textColor     = Colors.qDarkGrey
        view.numberOfLines = 0
        view.text          = "The habitual action following the cue"
        return view
    }()
    
    lazy var routineVStack: UIStackView = {
        let view     = UIStackView(arrangedSubviews: [self.routineTitleLabel, self.routineContentLabel])
        view.axis    = .vertical
        view.spacing = 16
        return view
    }()
    
    lazy var rewardTitleLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Reward: "
        view.font      = UIFont.systemFont(ofSize: 18, weight: .bold)
        return view
    }()
    
    lazy var rewardContentLabel: UILabel = {
        let view           = UILabel()
        view.font          = UIFont.systemFont(ofSize: 18)
        view.textColor     = Colors.qDarkGrey
        view.numberOfLines = 0
        view.text          = "The positive feeling that is delivered at the end of the routine"
        return view
    }()
    
    lazy var rewardVStack: UIStackView = {
        let view     = UIStackView(arrangedSubviews: [self.rewardTitleLabel, self.rewardContentLabel])
        view.axis    = .vertical
        view.spacing = 16
        return view
    }()
    
    // -----------------------------------------
    // MARK: Initialization
    // -----------------------------------------
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    func setupUI() {
        [cueVStack, routineVStack, rewardVStack].forEach {addSubview($0)}
        
        cueVStack.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil)
        
        routineVStack.anchor(top: cueVStack.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 0), size: .zero)
        
        rewardVStack.anchor(top: routineVStack.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 24, left: 0, bottom: 0, right: 0), size: .zero)
    }
}
