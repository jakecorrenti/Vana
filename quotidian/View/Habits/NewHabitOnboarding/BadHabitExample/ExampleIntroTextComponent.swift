//
//  ExampleIntroTextComponent.swift
//  Vana
//
//  Created by Jake Correnti on 3/21/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class ExampleIntroTextComponent: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Here's an example!"
        view.font = .boldSystemFont(ofSize: 30)
        view.textAlignment = .center
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Use this example habit as a reference if you would like."
        view.font = .boldSystemFont(ofSize: 17)
        view.textColor = Colors.qDarkGrey
        view.numberOfLines = 0
        view.textAlignment = .center
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
        [titleLabel, subtitleLabel].forEach {addSubview($0)}
        
        constrainTitleLabel()
        constrainSubTitleLabel()
    }
    
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainSubTitleLabel() {
        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
