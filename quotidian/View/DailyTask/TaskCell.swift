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
    
    lazy var reminderImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: Images.bell)
        return view
    }()
    
    lazy var checklistImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: Images.list)
        return view
    }()
    
    lazy var repeatImage: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(systemName: Images.repeatRing)
        return view
    }()
    
    lazy var propertiesImageStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.distribution = .equalCentering
        view.spacing = 8
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
    
    func setupUI() {
        [reminderImage, checklistImage, repeatImage].forEach {propertiesImageStack.addArrangedSubview($0)}
        [containerView, titleLabel, descriptionLabel, propertiesImageStack].forEach {addSubview($0)}
        
        containerView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 8, left: 16, bottom: 8, right: 16), size: .zero)
        
        titleLabel.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 19, left: 13, bottom: 0, right: 0), size: .zero)
        
        descriptionLabel.anchor(top: titleLabel.bottomAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 19, left: 13, bottom: 0, right: 0), size: .zero)
        
        propertiesImageStack.anchor(top: containerView.topAnchor, leading: nil, bottom: containerView.bottomAnchor, trailing: containerView.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 10, left: 0, bottom: 10, right: 13), size: .init(width: containerView.frame.height / 2, height: 0))
        
    }
    
    func configure(task: Task) {
        titleLabel.text       = task.title
        descriptionLabel.text = task.taskDescription
        
        if task.reminderShortTime == "" {
            reminderImage.image = UIImage()
        }

        if task.checkListItems.count == 0 {
            checklistImage.image = UIImage()
        }

        if task.repeatDays.count == 0 {
            repeatImage.image = UIImage()
        }
    }
}
