//
//  TimePickerCell.swift
//  quotidian
//
//  Created by Jake Correnti on 1/27/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class TimePickerCell: UITableViewCell {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    var delegate: TimeChangedDelegate?
    
    lazy var datePicker: UIDatePicker = {
        let view = UIDatePicker()
        view.datePickerMode = .time
        view.addTarget(self, action: #selector(timeValueChanged), for: .valueChanged)
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
        addSubview(datePicker)
        
        datePicker.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .zero, size: .zero)
    }
    
    @objc func timeValueChanged() {
        delegate?.updateTime(time: datePicker.date)
    }
}
