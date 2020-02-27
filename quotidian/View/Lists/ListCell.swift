//
//  ListCell.swift
//  quotidian
//
//  Created by Jake Correnti on 2/24/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class ListCell: UICollectionViewCell {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var listColorView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 25
        view.layer.masksToBounds = true
        view.backgroundColor = Colors.qPurple
        return view
    }()
    
    lazy var listNameLabel: UILabel = {
        let view = UILabel()
        view.text = "List Name"
        view.textColor = .black
        view.textAlignment = .center
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    
    lazy var listNumTasksLabel: UILabel = {
        let view = UILabel()
        view.text = "3 tasks to complete"
        view.textColor = Colors.qDarkGrey
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 15)
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
        [listColorView, listNameLabel, listNumTasksLabel].forEach {addSubview($0)}
        
        listColorView.anchor(top: topAnchor, leading: nil, bottom: nil, trailing: nil, centerX: centerXAnchor, centerY: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 50, height: 50))
        listNameLabel.anchor(top: centerYAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .zero)
        listNumTasksLabel.anchor(top: listNameLabel.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 8, left: 8, bottom: 0, right: 8), size: .zero)
    }
    
    func configureCell(for list: UserList) {
        listColorView.backgroundColor = UIColor(named: list.bgColorName)
        listNameLabel.text = list.name
        listNumTasksLabel.text = "\(list.tasks.count) task(s) in \(list.name)"
    }
}
