//
//  ContactDetailViewModel.swift
//  PrivusCall
//
//  Created by Sachin on 20/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit
import Contacts

class ContactDetailViewModel: ContactViewModel {

    override init(contactData: CNContact) {
        super.init(contactData: contactData)
    }
    
    var fullName: String {
        return contact.givenName + " " + contact.familyName
    }

    var emailString: String? {
        return contact.emailAddresses.first?.value as String?
    }
    
    var streetAddressString: String? {
        return contact.postalAddresses.first?.value.street
    }
    
    var cityString: String? {
        return contact.postalAddresses.first?.value.city
    }
    
    var state: String? {
        return contact.postalAddresses.first?.value.state
    }
    
    var zipCode: String? {
        return contact.postalAddresses.first?.value.postalCode
    }
    
}
