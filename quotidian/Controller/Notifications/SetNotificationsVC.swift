//
//  SetNotificationsVC.swift
//  Vana
//
//  Created by Jake Correnti on 3/22/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class SetNotificationsVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    let notificationsManager = LocalNotificationsManager()
    let dbManager = RealmStorageContext()
    var isNotificationPresent = false
    let realm = try! Realm()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    let setNotificationsComponent = SetupNotificationsComponent()
    let editNotificationsComponent = EditNotificationsComponent()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = true
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.bgColor)

        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        navigationItem.rightBarButtonItem = doneButton
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    private func verifyNotificationsExist() -> Bool {
        if notificationsManager.listNumberOfNotificationsScheduled() == 0 {
            return false
        }
        
        return true
    }
    
    private func setupUI() {
        if verifyNotificationsExist() {
            // use the edit notifications view
            isNotificationPresent = true
            setupEditNotificationsUI()
        } else {
            // use the setupNotifications view
            setupSetNotificationsUI()
        }
    }
    
    private func setupSetNotificationsUI() {
        view.addSubview(setNotificationsComponent)
        
        setNotificationsComponent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            setNotificationsComponent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            setNotificationsComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            setNotificationsComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            setNotificationsComponent.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupEditNotificationsUI() {
        view.addSubview(editNotificationsComponent)
        
        editNotificationsComponent.removeReminderButton.addTarget(self, action: #selector(removeReminderButtonPressed), for: .touchUpInside)
        editNotificationsComponent.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            editNotificationsComponent.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            editNotificationsComponent.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            editNotificationsComponent.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            editNotificationsComponent.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func getNotificationTime() -> Date {
        if isNotificationPresent {
            // check edit notification text field
            let timeFull: Date = editNotificationsComponent.timeFull
            return timeFull
        } else {
            // check set notification text field
            let timeFull: Date = setNotificationsComponent.timeFull
            return timeFull
        }
    }
    
    private func getReminderHourComponent() -> Int {
        return Calendar.current.component(.hour, from: getNotificationTime())
    }
    
    private func getReminderMinuteComponent() -> Int {
        return Calendar.current.component(.minute, from: getNotificationTime())
    }
    
    private func createNotification() {
        var notifications = [LocalNotification]()
        
        (1...7).forEach { day in
            var notificationsComponent = DateComponents()
            notificationsComponent.weekday = day
            notificationsComponent.hour = getReminderHourComponent()
            notificationsComponent.minute = getReminderMinuteComponent()
            
            let id = UUID().uuidString
            
            notifications.append(LocalNotification(
                id: id,
                title: "Don't forget to complete your routines for the day!",
                dateTime: notificationsComponent,
                isRepeating: true
            ))
        }
        notificationsManager.notifications = notifications
        notificationsManager.schedule()
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneButtonPressed() {
        
        if isNotificationPresent {
            // update the notification time
            let habitNotification = realm.objects(GeneralHabitNotification.self).first!
            try? dbManager.delete(object: habitNotification)
            
            let newNotification = GeneralHabitNotification()
            newNotification.time = getNotificationTime()
            try? dbManager.save(object: newNotification)
            createNotification()
            
        } else {
            let habitReminderTime = GeneralHabitNotification()
            habitReminderTime.time = getNotificationTime()
            
            try? dbManager.save(object: habitReminderTime)
            createNotification()
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    @objc func removeReminderButtonPressed() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        try? dbManager.delete(object: realm.objects(GeneralHabitNotification.self).first!)
        dismiss(animated: true, completion: nil)
    }
}
