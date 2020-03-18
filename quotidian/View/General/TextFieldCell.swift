//
//  TextFieldCell.swift
//  quotidian
//
//  Created by Jake Correnti on 1/27/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TextFieldCell: UITableViewCell {

    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var textField: UITextField = {
        let view             = UITextField()
        view.backgroundColor = UIColor(named: ColorNames.accessoryBGColor)
        view.font            = UIFont.systemFont(ofSize: 15)
        view.delegate        = self
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
        addSubview(textField)
        
        textField.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    func configure(placeholder: String) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: Colors.qDarkGrey,
            .font: UIFont.systemFont(ofSize: 15)
        ])
    }
}

// -----------------------------------------
// MARK: Extensions 
// -----------------------------------------

extension TextFieldCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
