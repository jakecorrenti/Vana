//
//  CompletionButtonCell.swift
//  quotidian
//
//  Created by Jake Correnti on 2/3/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class CompletionButtonCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
//    var delegate: TaskCompletedDelegate?
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var button: UIButton = {
        let view = UIButton(type: .system)
        view.layer.cornerRadius  = 12
        view.layer.masksToBounds = true
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        return view
    }()
    
    // -----------------------------------------
    // MARK: Initializiation
    // -----------------------------------------
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupUI()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup Views
    // -----------------------------------------
    
    func setupUI() {
        addSubview(button)
        
        button.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 16), size: .zero)
    }
    
    func configure(title: String, backgroundColor: UIColor, titleColor: UIColor, buttonType: String) {
        button.setTitle(title, for: .normal)
        button.setTitleColor(titleColor, for: .normal)
        button.backgroundColor = backgroundColor
        
        if buttonType == "complete" {
            button.addTarget(self, action: #selector(completed), for: .touchUpInside)
        } else {
            button.addTarget(self, action: #selector(deleted), for: .touchUpInside)
        }
        
    }
    
    // -----------------------------------------
    // MARK: View Interaction
    // -----------------------------------------
    
    @objc func completed() {
//        delegate?.completionFor(status: true)
    }
    
    @objc func deleted() {
//        delegate?.completionFor(status: false )
    }
}
