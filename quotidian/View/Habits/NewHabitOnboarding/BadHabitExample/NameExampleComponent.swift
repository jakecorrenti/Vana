//
//  NameExampleComponent.swift
//  Vana
//
//  Created by Jake Correnti on 3/21/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class NameExampleComponent: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Name:"
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Procrastination"
        view.textColor = Colors.qDarkGrey
        view.font = .systemFont(ofSize: 18)
        return view
    }()
    
    lazy var vStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
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
            vStack.topAnchor.constraint(equalTo: topAnchor),
            vStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
}
