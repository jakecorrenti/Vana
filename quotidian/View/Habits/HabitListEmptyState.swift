//
//  HabitListEmptyState.swift
//  Vana
//
//  Created by Jake Correnti on 3/17/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class HabitListEmptyState: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var vStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.titleLabel, self.messageLabel])
        view.axis = .vertical
        view.spacing = 16
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Oh no! You haven't created any Habits!"
        view.numberOfLines = 0
        view.textAlignment = .center
        view.font = .init(descriptor: .preferredFontDescriptor(withTextStyle: .headline), size: 20)
        return view
    }()
    
    lazy var messageLabel: UILabel = {
        let view = UILabel()
        view.text = "Press the 'plus' button on the top right to create a new Habit"
        view.numberOfLines = 0
        view.textAlignment = .center
        view.textColor = Colors.qDarkGrey
        view.font = .init(descriptor: .preferredFontDescriptor(withTextStyle: .subheadline), size: 15)
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
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor),
            vStack.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
