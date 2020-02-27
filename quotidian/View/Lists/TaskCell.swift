//
//  TaskCell.swift
//  quotidian
//
//  Created by Jake Correnti on 1/30/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var containerView: UIView = {
        let view                 = UIView()
        view.layer.cornerRadius  = 12
        view.layer.masksToBounds = true
        view.backgroundColor     = Colors.qWhite
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view       = UILabel()
        view.text      = "Title"
        view.font      = UIFont.boldSystemFont(ofSize: 25)
        view.textColor = .black
        return view
    }()
    
    lazy var descriptionLabel: UILabel = {
        let view       = UILabel()
        view.text      = "DESCRIPTION"
        view.font      = UIFont.systemFont(ofSize: 18)
        view.textColor = .lightGray
        return view
    }()
    
    // -----------------------------------------
    // MARK: Initialization
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
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupUI() {
        [containerView, titleLabel, descriptionLabel].forEach {addSubview($0)}
        
        containerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 16), size: .zero)
        
        titleLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 19, left: 13, bottom: 0, right: 13), size: .zero)
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 19, left: 13, bottom: 0, right: 13), size: .zero)
        
    }
    
    func configure(task: Task) {
        titleLabel.text       = task.name
        descriptionLabel.text = task.notes
    }
}
