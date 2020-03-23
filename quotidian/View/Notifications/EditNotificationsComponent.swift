//
//  EditNotificationsComponent.swift
//  Vana
//
//  Created by Jake Correnti on 3/23/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class EditNotificationsComponent: UIView {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    let realm = try! Realm()
    var timeFull = Date()
    var formatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        return formatter
    }
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 0
        view.font = .boldSystemFont(ofSize: 25)
        view.textAlignment = .center
        return view
    }()
    
    lazy var subTitleLabel: UILabel = {
        let view = UILabel()
        view.text = "You may change the reminder time or remove it all together"
        view.numberOfLines = 0
        view.font = .systemFont(ofSize: 18)
        view.textAlignment = .center
        view.textColor = Colors.qDarkGrey
        return view
    }()
    
    lazy var timePickerTextField: UITextField = {
        let view = UITextField()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 50)
        return view
    }()
    
    lazy var editButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Edit", for: .normal)
        view.setTitleColor(Colors.qPurple, for: .normal)
        view.titleLabel?.font = .boldSystemFont(ofSize: 18)
        view.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        return view
    }()
    
    lazy var removeReminderButton: UIButton = {
        let view = UIButton(type: .system)
        view.setTitle("Remove reminder", for: .normal)
        view.setTitleColor(Colors.qWhite, for: .normal)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.backgroundColor = Colors.qDeleteRed
        view.titleLabel?.font = .boldSystemFont(ofSize: 15)
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
        getNotificationTime()
        [titleLabel, subTitleLabel, timePickerTextField, editButton, removeReminderButton].forEach { addSubview($0)}
        
        createToolbar()
        createDayPicker()
        constrainTitleLabel()
        constrainSubTitleLabel()
        constrainTimePickerTextField()
        constrainEditButton()
        constrainRemoveReminderButton()
    }
    
    private func createToolbar() {
        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(dismissKeyboard))
        
        toolBar.setItems([doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        
        timePickerTextField.inputAccessoryView = toolBar
    }
    
    private func createDayPicker() {
        
        dayPicker.datePickerMode = .time
        dayPicker.date = realm.objects(GeneralHabitNotification.self).first?.time ?? Date()
        dayPicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        
        timePickerTextField.inputView = dayPicker
        
    }
    
    private func getNotificationTime() {
        let notificationDetails = realm.objects(GeneralHabitNotification.self).first
        let time = notificationDetails?.time ?? Date()
        let formattedTime = formatter.string(from: time)
        titleLabel.text = "You currently have a notification set for \(formattedTime)"
    }
    
    private func constrainTitleLabel() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 36),
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainSubTitleLabel() {
        subTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            subTitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainTimePickerTextField() {
        let time = realm.objects(GeneralHabitNotification.self).first?.time ?? Date()
        timePickerTextField.text = formatter.string(from: time)
        
        timePickerTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            timePickerTextField.bottomAnchor.constraint(equalTo: centerYAnchor),
            timePickerTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            timePickerTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainEditButton() {
        editButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editButton.topAnchor.constraint(equalTo: timePickerTextField.bottomAnchor, constant: 16),
            editButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            editButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }
    
    private func constrainRemoveReminderButton() {
        removeReminderButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            removeReminderButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            removeReminderButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            removeReminderButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            removeReminderButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    @objc func editButtonPressed() {
        // when the button is pressed, it enables the text field, sets it as the first responder
        timePickerTextField.isEnabled = true
        timePickerTextField.becomeFirstResponder()
    }
    
    @objc func datePickerValueChanged() {
        timePickerTextField.text = formatter.string(from: dayPicker.date)
        timeFull = dayPicker.date
    }

}
