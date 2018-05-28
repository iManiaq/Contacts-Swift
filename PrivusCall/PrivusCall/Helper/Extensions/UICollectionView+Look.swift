//
//  UICollectionView+Look.swift
//  PrivusCall
//
//  Created by Sachin on 21/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit

extension UICollectionViewCell {
    
    public class var identifier : String {
        var name = NSStringFromClass(self)
        name = name.components(separatedBy: ".").last!
        return name
    }
    
}
