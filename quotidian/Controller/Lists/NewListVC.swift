//
//  NewListVC.swift
//  quotidian
//
//  Created by Jake Correnti on 2/23/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class NewListVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    let dbManager: StorageContext = RealmStorageContext()
    var selectedColorIndex = 0
    var selectedColor = "" // variable is used for editing the list

    let colorValues: [UIColor] = [
        Colors.qListOrange,
        Colors.qListRed,
        Colors.qListBlue,
        Colors.qListGreen,
        Colors.qListPurple
    ]
    
    let colorNames: [String] = [
        "qListGray",
        "qListOrange",
        "qListRed",
        "qListBlue",
        "qListGreen",
        "qListPurple"
    ]
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    var doneButton = UIBarButtonItem()
    
    lazy var textFieldBGView: UIView = {
        let view = UIView()
        view.layer.cornerRadius  = 12
        view.layer.masksToBounds = true
        view.backgroundColor = Colors.qListGray
        return view
    }()
    
    lazy var listTF: UITextField = {
        let view = UITextField()
        view.textColor = Colors.qWhite
        view.font = UIFont.boldSystemFont(ofSize: 30)
        view.textAlignment = .center
        view.placeholder = "List name..."
        view.autocorrectionType = .yes
        view.delegate = self
        view.addTarget(self, action: #selector(continuouslyCheckTFContents), for: .editingChanged)
        return view
    }()
    
    lazy var selectColorLabel: UILabel = {
        let view = UILabel()
        view.text = "Select color"
        view.font = UIFont.boldSystemFont(ofSize: 18)
        view.textColor = .black
        return view
    }()
    
    lazy var colorsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Colors.qBG
        view.delegate = self
        view.dataSource = self
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Cells.defaultCell)
        return view
    }()
    
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
    
    func setupNavBar() {
        view.backgroundColor = Colors.qBG
        navigationItem.title = "New list"
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonPressed))
        doneButton.isEnabled = false
        navigationItem.rightBarButtonItem = doneButton
    }
    
    func setupUI() {
        [textFieldBGView, listTF, selectColorLabel, colorsCV].forEach {view.addSubview($0)}
        
        textFieldBGView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 24, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: view.frame.height / 5))
        listTF.anchor(top: nil, leading: textFieldBGView.leadingAnchor, bottom: nil, trailing: textFieldBGView.trailingAnchor, centerX: nil, centerY: textFieldBGView.centerYAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .zero)
        selectColorLabel.anchor(top: textFieldBGView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 36, left: 16, bottom: 0, right: 16), size: .zero)
        colorsCV.anchor(top: selectColorLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 16, left: 16, bottom: 0, right: 16), size: .init(width: 0, height: 60))
    }
    
    func createUserListObject() -> UserList {
        let list = UserList()
        list.name = listTF.text!
        list.bgColorName = colorNames[selectedColorIndex]
        return list
    }
    
    @objc func continuouslyCheckTFContents() {
        if listTF.text == "" || listTF.text == nil || listTF.text == " " {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
    }
    
    @objc func doneButtonPressed() {
        print(createUserListObject())
        
        try? dbManager.save(object: createUserListObject())
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true)
    }
}

extension NewListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension NewListVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
}

extension NewListVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        textFieldBGView.backgroundColor = colorValues[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.layer.borderColor = UIColor.black.cgColor
        cell?.contentView.layer.borderWidth = 3
        cell?.contentView.layer.cornerRadius = 26
        selectedColorIndex = indexPath.row + 1
        selectedColor = colorNames[indexPath.row + 1]
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.contentView.layer.borderWidth = 0
        cell?.contentView.layer.borderColor = UIColor.clear.cgColor
    }
}

extension NewListVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colorValues.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.defaultCell, for: indexPath)
        cell.backgroundColor = colorValues[indexPath.row]
        cell.layer.cornerRadius = 26
        return cell
    }
}
