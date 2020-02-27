//
//  MyListsVC.swift
//  quotidian
//
//  Created by Jake Correnti on 1/25/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import RealmSwift

class MyListsVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    private let realm = try! Realm()
    private var listsInProgress = List<UserList>()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var listsIPLabel: UILabel = {
        let view = UILabel()
        view.text = "Lists in progress"
        view.textColor = .black
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    
    lazy var listsInProgressCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = .red
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = Colors.qBG
        view.showsHorizontalScrollIndicator = false
        view.register(ListInProgressCell.self, forCellWithReuseIdentifier: Cells.listInProgressCell)
        return view
    }()
    
    lazy var allListsLabel: UILabel = {
        let view = UILabel()
        view.text = "All lists"
        view.textColor = .black
        view.font = UIFont.boldSystemFont(ofSize: 18)
        return view
    }()
    
    lazy var allListsCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.backgroundColor = Colors.qBG
        view.delegate = self
        view.dataSource = self
        view.register(ListCell.self, forCellWithReuseIdentifier: Cells.listCell)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: Cells.defaultCell)
        return view
    }()
    // -----------------------------------------
    // MARK: Life Cycle
    // -----------------------------------------
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reloadCollectionViewData()
        getListsInProgress()
        
        LocalNotificationsManager().listScheduledNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupUI()
        
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        getListsInProgress()
        
        
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = Colors.qBG
       
        navigationItem.title = "Lists"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: Images.plus), style: .plain, target: self, action: #selector(addButtonPressed))
        navigationItem.rightBarButtonItem = addButton
        navigationItem.backBarButtonItem  = UIBarButtonItem(title: "", style: .plain, target: self, action: nil)
        
    }
    
    private func setupUI() {
        [listsIPLabel, listsInProgressCV, allListsLabel, allListsCV].forEach {view.addSubview($0)}
        
        listsIPLabel.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 24, left: 16, bottom: 0, right: 16), size: .zero)
        listsInProgressCV.anchor(top: listsIPLabel.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 86))
        allListsLabel.anchor(top: listsInProgressCV.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 24, left: 16, bottom: 0, right: 16), size: .zero)
        allListsCV.anchor(top: allListsLabel.bottomAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0), size: .zero)
    }
    
    private func reloadCollectionViewData() {
        listsInProgressCV.reloadData()
        allListsCV.reloadData()
    }
    
    private func getListsInProgress() {
        let lists = realm.objects(UserList.self)
        
        let listsInProgress = List<UserList>()
        
        for list in lists {
            if list.isInProgress() {
                listsInProgress.append(list)
            }
        }
        
        self.listsInProgress = listsInProgress
    }
    
    @objc func addButtonPressed() {
        navigationController?.pushViewController(NewListVC(), animated: true)
    }
}

// -----------------------------------------
// MARK: Flow Layout Delegate
// -----------------------------------------

extension MyListsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == allListsCV {
            let width = view.frame.width - 32
            return CGSize(width: width / 2, height: width / 2)
        } else if collectionView == listsInProgressCV {
            return CGSize(width: 250, height: 70)
        }
        
        return CGSize()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}

// -----------------------------------------
// MARK: Delegate
// -----------------------------------------

extension MyListsVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == allListsCV {
            let listDetail = ListDetailVC()
            listDetail.selectedList = realm.objects(UserList.self)[indexPath.row]
            navigationController?.pushViewController(listDetail, animated: true)
        }
        
    }
}

// -----------------------------------------
// MARK: Data Source 
// -----------------------------------------

extension MyListsVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == allListsCV {
            return realm.objects(UserList.self).count
        } else if collectionView == listsInProgressCV {
            return listsInProgress.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == allListsCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.listCell, for: indexPath) as! ListCell
            cell.configureCell(for: realm.objects(UserList.self)[indexPath.row])
            cell.layer.cornerRadius = 12
            cell.backgroundColor = Colors.qWhite
            return cell
        } else if collectionView == listsInProgressCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Cells.listInProgressCell, for: indexPath) as! ListInProgressCell
            cell.backgroundColor = Colors.qWhite
            cell.configureFor(list: listsInProgress[indexPath.row])
            cell.layer.cornerRadius = 12 
            return cell
        }
        
        return UICollectionViewCell()
    }
}

