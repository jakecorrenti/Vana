//
//  RoutineExampleComponent.swift
//  Vana
//
//  Created by Jake Correnti on 3/21/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class RoutineExampleComponent: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Original/Faulty Routine:"
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    
    lazy var action1: UILabel = {
        let view = UILabel()
        view.text = "- Get home from school"
        view.font = .systemFont(ofSize: 18)
        view.textColor = Colors.qDarkGrey
        return view
    }()
    
    lazy var action2: UILabel = {
        let view = UILabel()
        view.text = "- Eat a snack"
        view.font = .systemFont(ofSize: 18)
        view.textColor = Colors.qDarkGrey
        return view
    }()
    
    lazy var action3: UILabel = {
        let view = UILabel()
        view.text = "- Watch YouTube"
        view.font = .systemFont(ofSize: 18)
        view.textColor = Colors.qDarkGrey
        return view
    }()
    
    lazy var action4: UILabel = {
        let view = UILabel()
        view.text = "- Code"
        view.font = .systemFont(ofSize: 18)
        view.textColor = Colors.qDarkGrey
        return view
    }()
    
    lazy var action5: UILabel = {
        let view = UILabel()
        view.text = "- Start homework"
        view.font = .systemFont(ofSize: 18)
        view.textColor = Colors.qDarkGrey
        return view
    }()
    
    lazy var action6: UILabel = {
        let view = UILabel()
        view.text = "- Finish homework"
        view.font = .systemFont(ofSize: 18)
        view.textColor = Colors.qDarkGrey
        return view
    }()
    
    lazy var actionStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.action1, self.action2, self.action3, self.action4, self.action5, self.action6])
        view.axis = .vertical
        view.spacing = 8
        return view
    }()
    
    lazy var vStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.titleLabel, self.actionStack])
        view.axis = .vertical
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
    
    private func setupUI() {
        addSubview(vStack)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
        ])
    }

}
