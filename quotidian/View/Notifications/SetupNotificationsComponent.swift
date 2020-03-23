//
//  SetupNotificationsComponent.swift
//  Vana
//
//  Created by Jake Correnti on 3/22/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class SetupNotificationsComponent: UIView {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    var timeFull = Date()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Set a reminder to complete your routines"
        view.numberOfLines = 0
        view.font = .boldSystemFont(ofSize: 25)
        view.textAlignment = .center
        return view
    }()
    
    lazy var timePickerTextField: UITextField = {
        let view = UITextField()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 50)
        view.becomeFirstResponder()
        view.text = self.formatter.string(from: Date())
        return view
    }()
    
    let dayPicker = UIDatePicker()
    
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
        [titleLabel, timePickerTextField].forEach {addSubview($0)}
        
        constrainTitleLabel()
        createDayPicker()
        constrainTimePickerTextField()
    }
    
    private func createDayPicker() {
        dayPicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dayPicker.datePickerMode = .time
        
        timePickerTextField.inputView = dayPicker
        
    }

    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 36),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    private func constrainTimePickerTextField() {
        timePickerTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePickerTextField.bottomAnchor.constraint(equalTo: centerYAnchor),
            timePickerTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timePickerTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    @objc func datePickerValueChanged() {
        timePickerTextField.text = formatter.string(from: dayPicker.date)
        timeFull = dayPicker.date
    }

}
