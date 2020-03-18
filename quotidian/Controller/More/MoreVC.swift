//
//  MoreVC.swift
//  Vana
//
//  Created by Jake Correnti on 3/16/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import SafariServices
import StoreKit

class MoreVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    private var cellTitles = [
        "Send anonymous feedback",
        "Follow me on Instagram",
        "Rate Vana",
        "Privacy policy"
    ]
    
    private var imageNames = [
        Images.paperPlane,
        Images.camera,
        Images.star,
        Images.lock
    ]
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var avatarView = AvatarView()
    
    lazy var tableView: UITableView = {
        let view = UITableView(frame: .zero, style: .insetGrouped)
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = UIColor(named: ColorNames.bgColor)
        view.register(UITableViewCell.self, forCellReuseIdentifier: Cells.defaultCell)
        return view
    }()
    
    // -----------------------------------------
    // MARK: Lifecycle
    // -----------------------------------------
    
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
        navigationItem.title = "More"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupUI() {
        [avatarView, tableView].forEach { view.addSubview($0) }
        
        constrainAvatarView()
        constrainTableView()
    }
    
    private func constrainAvatarView() {
        avatarView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            avatarView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            avatarView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func constrainTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: avatarView.subtitleLabel.bottomAnchor, constant: 36),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func redirectUserToMyInstagram() {
        let instagramHooks = "https://www.instagram.com/jaketheprogrammer/"
        let instagramUrl = NSURL(string: instagramHooks)
        if UIApplication.shared.canOpenURL(instagramUrl! as URL) {
            UIApplication.shared.open(instagramUrl! as URL)
        } else {
          //redirect to safari because the user doesn't have Instagram
            UIApplication.shared.open(NSURL(string: "https://www.instagram.com/jaketheprogrammer/")! as URL)
        }
    }
    
    private func redirectUserToPrivacyPolicy() {
        let policyHooks = "https://vana.flycricket.io/privacy.html"
        let policyURL = NSURL(string: policyHooks)
        present(SFSafariViewController(url: policyURL! as URL), animated: true, completion: nil)
    }
    
    private func requestUserReview() {
        SKStoreReviewController.requestReview() // temporary until get the official link to app
    }
}

// -----------------------------------------
// MARK: Table View Protocols
// -----------------------------------------

extension MoreVC : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Cells.defaultCell, for: indexPath)
        cell.textLabel?.text = cellTitles[indexPath.row]
        cell.accessoryType = .disclosureIndicator
        cell.textLabel?.font = .boldSystemFont(ofSize: 15)
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(named: ColorNames.accessoryBGColor)
        cell.imageView?.image = UIImage(systemName: imageNames[indexPath.row])
        return cell
    }
    
    
}

extension MoreVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
            present(UINavigationController(rootViewController: SendFeedbackVC()), animated: true, completion: nil)
        case 1:
            redirectUserToMyInstagram()
        case 2:
            // redirect users to be able to rate the app
            requestUserReview()
        case 3:
            redirectUserToPrivacyPolicy()
        default:
            print("the selected index does not exist")
        }
    }
}
