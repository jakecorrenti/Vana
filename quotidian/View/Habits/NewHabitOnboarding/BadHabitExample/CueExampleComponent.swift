//
//  CueExampleComponent.swift
//  Vana
//
//  Created by Jake Correnti on 3/21/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class CueExampleComponent: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Cue:"
        view.font = .boldSystemFont(ofSize: 18)
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "Getting home from school"
        view.font = .systemFont(ofSize: 18)
        view.textColor = Colors.qDarkGrey
        return view
    }()
    
    lazy var vStack: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        view.spacing = 16
        view.axis = .vertical
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
            vStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

}
