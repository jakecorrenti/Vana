//
//  TextFieldWithImageCell.swift
//  quotidian
//
//  Created by Jake Correnti on 2/20/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TextFieldWithImageCell: UITableViewCell {

    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var cellImage: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFit
        return view
    }()
    
    lazy var textField: UITextField = {
        let view             = UITextField()
        view.backgroundColor = Colors.qWhite
        view.textColor       = Colors.qDarkGrey
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
        [cellImage, textField].forEach {addSubview($0)}
        
        cellImage.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, centerX: nil, centerY: nil, padding: .init(top: 8, left: 8, bottom: 8, right: 0), size: .init(width: frame.height - 16, height: 0))
        
        textField.anchor(top: topAnchor, leading: cellImage.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
    }
    
    func configure(placeholder: String, image: UIImage) {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [
            .foregroundColor: Colors.qDarkGrey,
            .font: UIFont.systemFont(ofSize: 15)
        ])
        
        cellImage.image = image 
    }
}

// -----------------------------------------
// MARK: Extensions
// -----------------------------------------

extension TextFieldWithImageCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

