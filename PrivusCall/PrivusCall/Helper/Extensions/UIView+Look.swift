//
//  UIView+Look.swift
//  PrivusCall
//
//  Created by Sachin on 21/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
    }

    func addBorder() {
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1.0
    }
    
    func addDarkShadow() {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: -2)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 10
    }
    
}

extension UITextField {
    
    var nonnullText: String {
        return self.text ?? ""
    }
    
    var nonnullNSText: NSString {
        return (self.text  ?? "") as NSString
    }
    
}
