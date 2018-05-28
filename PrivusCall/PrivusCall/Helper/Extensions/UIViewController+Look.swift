//
//  UIViewController+Look.swift
//  PrivusCall
//
//  Created by Sachin on 21/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public class var identifier : String {
        var name = NSStringFromClass(self)
        name = name.components(separatedBy: ".").last!
        return name
    }
    
    public var isVisible : Bool{
        get {
            if self.view.window != nil {
                return true
            } else {
                return false
            }
        }
    }

    @discardableResult
    public func displayAlertWith(title:String,message:String,leftTitle:String?,rightTitle:String?,completionHandler: ((UIAlertAction?)->Void)!) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle:UIAlertControllerStyle.alert)
        if leftTitle != nil {
            let leftAction = UIAlertAction(title: leftTitle!, style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                if completionHandler != nil {
                    completionHandler(alert)
                }
            })
            alert.addAction(leftAction)
        }
        
        if rightTitle != nil {
            let rightAction = UIAlertAction(title: rightTitle!, style: UIAlertActionStyle.default, handler: { (alert:UIAlertAction!) -> Void in
                if completionHandler != nil {
                    completionHandler(alert)
                }
            })
            alert.addAction(rightAction)
        }
        self.present(alert, animated: true, completion: nil)
        return alert
    }
}
    
