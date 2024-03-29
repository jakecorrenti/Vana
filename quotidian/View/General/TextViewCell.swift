//
//  TextViewCell.swift
//  quotidian
//
//  Created by Jake Correnti on 1/27/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TextViewCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var textView: UITextView = {
        let view       = UITextView()
        view.textColor = Colors.qDarkGrey
        view.font      = UIFont.systemFont(ofSize: 15)
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
        addSubview(textView)
        
        textView.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16), size: .zero)
    }
}
