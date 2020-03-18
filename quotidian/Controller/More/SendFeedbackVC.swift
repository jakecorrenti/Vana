//
//  SendFeedbackVC.swift
//  Vana
//
//  Created by Jake Correnti on 3/16/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit
import FirebaseFirestore

class SendFeedbackVC: UIViewController {
    
    // -----------------------------------------
    // MARK: Properties
    // -----------------------------------------
    
    let db = Firestore.firestore()
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------

    lazy var sendButton = UIBarButtonItem(image: UIImage(systemName: Images.paperPlane), style: .done, target: self, action: #selector(sendButtonPressed))
    
    lazy var feedbackTextView: UITextView = {
        let view = UITextView()
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        view.delegate = self
        view.font = .systemFont(ofSize: 15)
        view.text = "Enter feedback..."
        view.backgroundColor = UIColor(named: ColorNames.accessoryBGColor)
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
        addTapGestureRecognizer()
    }
    
    // -----------------------------------------
    // MARK: Setup UI
    // -----------------------------------------
    
    private func setupNavBar() {
        view.backgroundColor = UIColor(named: ColorNames.bgColor)
        navigationItem.title = "Send feedback"
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonPressed))
        navigationItem.leftBarButtonItem = cancelButton
        navigationItem.rightBarButtonItem = sendButton
    }
    
    private func setupUI() {
        sendButton.isEnabled = false
        view.addSubview(feedbackTextView)
        constrainFeedbackTextView()
    }
    
    private func constrainFeedbackTextView() {
        feedbackTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feedbackTextView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            feedbackTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            feedbackTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            feedbackTextView.bottomAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func addTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap() {
        feedbackTextView.resignFirstResponder()
    }
    
    @objc func cancelButtonPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func sendButtonPressed() {
        db.collection("feedback").addDocument(data: ["feedback" : feedbackTextView.text!])
        dismiss(animated: true, completion: nil)
    }
}

// -----------------------------------------
// MARK: Text View Delegate
// -----------------------------------------

extension SendFeedbackVC: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == "" || textView.text == "Enter feedback..." || textView.text == " " {
            sendButton.isEnabled = false
        } else {
            sendButton.isEnabled = true
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Enter feedback..." {
            textView.text = ""
            textView.font = .systemFont(ofSize: 15)
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.text = "Enter feedback..."
            textView.font = .systemFont(ofSize: 15)
        }
    }
}
