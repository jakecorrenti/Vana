//
//  UINavigationController + Extension.swift
//  quotidian
//
//  Created by Jake Correnti on 2/26/20.
//  Copyright © 2020 Jake Correnti. All rights reserved.
//

import UIKit

extension UINavigationController {
    
    func setTintColor(color: UIColor) {
        navigationBar.tintColor = color
    }
    
    func setLargeTitleColor(color: UIColor) {
        navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : color]
    }
    
    func setTitleColor(color: UIColor) {
        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : color]
    }
    
    func setAllTo(color: UIColor) {
        setTintColor(color: color)
        setLargeTitleColor(color: color)
        setTitleColor(color: color)
    }
}
