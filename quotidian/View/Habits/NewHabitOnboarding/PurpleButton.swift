//
//  PurpleButton.swift
//  quotidian
//
//  Created by Jake Correnti on 2/13/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class PurpleButton: UIButton {
    
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
        
        backgroundColor     = Colors.qPurple
        layer.cornerRadius  = 12
        layer.masksToBounds = true
        setTitleColor(Colors.qWhite, for: .normal)
        
    }
    
    func configure(title: String) {
        setTitle(title, for: .normal)
        titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
    }
    
    func setDeactivatedState() {
        backgroundColor = Colors.qDeactivated
        setTitleColor(Colors.qDarkGrey, for: .normal)
        isEnabled = false
    }
    
    func setActivatedState() {
        backgroundColor = Colors.qPurple
        setTitleColor(Colors.qWhite, for: .normal)
        isEnabled = true
    }
}
