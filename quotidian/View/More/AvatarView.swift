//
//  AvatarView.swift
//  Vana
//
//  Created by Jake Correnti on 3/16/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class AvatarView: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var avatarImageView: UIImageView = {
        let view = UIImageView()
        view.image = UIImage(named: Images.instaIcon)
        view.contentMode = .scaleAspectFill
        view.layer.borderColor = Colors.qPurple.cgColor
        view.layer.borderWidth = 2
        view.layer.cornerRadius = 35
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let view = UILabel()
        view.text = "Hi! I'm Jake, and I made Vana"
        view.font = .boldSystemFont(ofSize: 15)
        return view
    }()
    
    lazy var subtitleLabel: UILabel = {
        let view = UILabel()
        view.text = "I'm a high school student in the United States trying to make my way into the dev world. Hopefully you like the app!"
        view.numberOfLines = 0
        view.textColor = Colors.qDarkGrey
        view.font = .systemFont(ofSize: 15)
        return view
    }()
    
    lazy var titleStackView: UIStackView = {
        let view = UIStackView(arrangedSubviews: [self.titleLabel, self.subtitleLabel])
        view.axis = .vertical
        view.spacing = 8
        return view
    }()

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
    // MARK: Configure UI
    // -----------------------------------------
    
    private func setupUI() {
        [avatarImageView, titleStackView].forEach { addSubview($0) }
        
        constrianAvatarImageView()
        constrainStackView()
    }
    
    private func constrianAvatarImageView() {
        avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 24),
            avatarImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            avatarImageView.heightAnchor.constraint(equalToConstant: 70),
            avatarImageView.widthAnchor.constraint(equalToConstant: 70)
        ])
    }
    
    private func constrainStackView() {
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleStackView.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            titleStackView.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 8),
            titleStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 16)
        ])
    }
}
