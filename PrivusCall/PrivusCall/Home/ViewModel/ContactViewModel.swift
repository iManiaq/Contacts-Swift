//
//  ContactViewModel.swift
//  PrivusCall
//
//  Created by Sachin on 20/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit
import Contacts

class ContactViewModel: ContactCellViewModel {
   
    internal let contact: CNContact
    var isPrivusContact = false
    
    init(contactData: CNContact) {
        contact = contactData
    }
    
    var firstName: String {
        return contact.givenName
    }
    
    var lastName: String {
        return contact.familyName
    }
    
    var attibutedNameString : NSAttributedString {
        let attrString = NSMutableAttributedString(string: contact.givenName,
                                                   attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.semibold)])
        
        attrString.append(NSMutableAttributedString(string: " " + contact.familyName,
                                                     attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0, weight: UIFont.Weight.regular)]))
        return attrString
    }
    
    var numberString: String {
        return contact.phoneNumbers.first?.value.stringValue ?? ""
    }
    
    var image: UIImage {
        var image: UIImage = UIImage(named: "unknown_dp")!
        if contact.imageDataAvailable {
            if let imageData = contact.thumbnailImageData ,let theImage = UIImage(data: imageData) {
                image = theImage
            }
        }
        return image
    }
    
    var largeImage: UIImage? {
        var image: UIImage = UIImage(named: "full_dp")!
        if contact.imageDataAvailable {
            if let imageData = contact.imageData ,let theImage = UIImage(data: imageData) {
                image = theImage
            }
        }
        return image
    }
    
    var timeString: String = ""

}
