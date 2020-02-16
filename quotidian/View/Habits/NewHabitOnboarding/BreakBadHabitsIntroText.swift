//
//  BreakBadHabitsIntroText.swift
//  quotidian
//
//  Created by Jake Correnti on 2/11/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

class BreakBadHabitsIntroText: UIView {
    
    // -----------------------------------------
    // MARK: Views
    // -----------------------------------------
    
    lazy var header: UILabel = {
        let view           = UILabel()
        view.textColor     = .black
        view.font          = UIFont.systemFont(ofSize: 30, weight: .bold)
        view.text          = "Break your bad habits!"
        view.textAlignment = .center
        return view
    }()
    
    lazy var subheader: UILabel = {
        let view           = UILabel()
        view.textColor     = Colors.qDarkGrey
        view.font          = UIFont.systemFont(ofSize: 17)
        view.numberOfLines = 0
        view.textAlignment = .center
        view.text          = "By separating your bad habits into three main parts, you are able to figure out what you need to change in order to break it!"
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
    // MARK: Setup UI
    // -----------------------------------------
    
    func setupUI() {
        [header, subheader].forEach {addSubview($0)}
        
        header.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil)
        
        subheader.anchor(top: header.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, centerX: nil, centerY: nil, padding: .init(top: 16, left: 0, bottom: 0, right: 0))
    }
}
