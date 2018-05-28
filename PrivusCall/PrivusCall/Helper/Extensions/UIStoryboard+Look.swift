//
//  UIStoryboard+Look.swift
//  PrivusCall
//
//  Created by Sachin on 21/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit

extension UIStoryboard
{
    class func viewController(fromStoryboardName storyBoardName : String, storyBoardIdentifier : String) -> AnyObject
    {
        let viewController:UIViewController = UIStoryboard(name: storyBoardName, bundle: nil).instantiateViewController(withIdentifier: storyBoardIdentifier)
        return viewController
    }
}

