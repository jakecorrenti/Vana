//
//  EditListVC.swift
//  quotidian
//
//  Created by Jake Correnti on 3/14/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class EditListVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    private let newListVC = NewListVC()
    var selectedList = UserList()
    
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
        populateUI()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationItem.title = "Edit list"
        
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveButtonPressed))
        navigationItem.rightBarButtonItem = saveButton
    }
    
    private func setupUI() {
        view.addSubview(newListVC.view)
        addChild(newListVC)
        newListVC.didMove(toParent: self)
        newListVC.view.isUserInteractionEnabled = true
        
        NSLayoutConstraint.activate([
            newListVC.view.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            newListVC.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            newListVC.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            newListVC.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func populateUI() {
        newListVC.textFieldBGView.backgroundColor = UIColor(named: selectedList.bgColorName)
        newListVC.listTF.text = selectedList.name
    }
    
    @objc func saveButtonPressed() {
        let dbManager: StorageContext = RealmStorageContext()

        let userList = UserList()
        userList.uid = selectedList.uid
        userList.name = newListVC.listTF.text!
        
        if newListVC.selectedColor == "" {
            userList.bgColorName = selectedList.bgColorName
        } else {
            userList.bgColorName = newListVC.selectedColor
        }
        
        try? dbManager.update(object: userList)
        navigationController?.popToRootViewController(animated: true)
    }
}
