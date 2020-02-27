//
//  ListInProgressCell.swift
//  quotidian
//
//  Created by Jake Correnti on 2/26/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class ListInProgressCell: UICollectionViewCell {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var listNameLabel: UILabel = {
        let view = UILabel()
        view.text = "List name"
        view.font = UIFont.boldSystemFont(ofSize: 15)
        view.textColor = .black
        return view
    }()
    
    lazy var completedRatioLabel: UILabel = {
        let view = UILabel()
        view.text = "999/999"
        view.textColor = Colors.qPurple
        view.font = UIFont.boldSystemFont(ofSize: 15)
        return view
    }()
    
    lazy var completedSubTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "tasks completed"
        view.font = UIFont.systemFont(ofSize: 11)
        view.textColor = Colors.qDarkGrey
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
        [completedSubTitleLabel, completedRatioLabel, listNameLabel].forEach {addSubview($0)}
        
        completedSubTitleLabel.anchor(top: centerYAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 0, bottom: 0, right: 16))
        completedRatioLabel.anchor(top: nil, leading: nil, bottom: centerYAnchor, trailing: nil, centerX: completedSubTitleLabel.centerXAnchor, centerY: nil)
        listNameLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: centerYAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: completedSubTitleLabel.frame.width), size: .zero)
    }
    
    func configureFor(list: UserList) {
        listNameLabel.text = list.name
        completedRatioLabel.text = "\(list.getTasksCompletedCount())/\(list.tasks.count)"
    }
}
