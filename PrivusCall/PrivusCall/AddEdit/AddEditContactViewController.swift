//
//  AddEditContactViewController.swift
//  PrivusCall
//
//  Created by Sachin on 27/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit
import Contacts

public typealias ContactAddAction = (_ contact: CNMutableContact) -> Void

final class AddEditContactViewController: UITableViewController {

    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    @IBOutlet weak var streetField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipCodeField: UITextField!
    
    var detailsViewModel: ContactDetailViewModel?
    var addEditMode: AddEditMode = .add
    var createContact: ContactAddAction?
    var editAndSaveContact: ContactAddAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }

    class func initController(viewModel: ContactDetailViewModel? = nil) -> AddEditContactViewController{
        let vc = UIStoryboard.viewController(fromStoryboardName: Storyboard.main, storyBoardIdentifier: AddEditContactViewController.identifier) as! AddEditContactViewController
        vc.detailsViewModel = viewModel
        return vc
    }

    func configureViewController() {
        addEditMode = (detailsViewModel != nil) ? AddEditMode.edit : AddEditMode.add
        configureNavigationItems()
    }
    
    func configureNavigationItems() {
        let rightButton: UIBarButtonItem!
        if addEditMode == .add {
            rightButton = UIBarButtonItem(title: "Add", style: .done, target: self, action: #selector(addContactAction))
        } else {
            rightButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(editContactAction))
            configureWithContact()
        }
        navigationItem.rightBarButtonItem = rightButton
    }
    
    func configureWithContact() {
        firstNameField.text = detailsViewModel?.firstName
        lastNameField.text =  detailsViewModel?.lastName
        phoneNumberField.text =  detailsViewModel?.numberString
        streetField.text =  detailsViewModel?.streetAddressString
        cityField.text =  detailsViewModel?.cityString
        stateField.text =  detailsViewModel?.streetAddressString
        zipCodeField.text =  detailsViewModel?.zipCode
    }
    
    @objc func addContactAction() {
        if isValidInput {
            createContact?(updatedContact())
            self.navigationController?.popViewController(animated: true)
        } else {
            invalidInputDataError()
        }
    }
    
     @objc func editContactAction() {
        if isValidInput {
            editAndSaveContact?(updatedContact())
            self.navigationController?.popViewController(animated: true)
        } else {
            invalidInputDataError()
        }
    }
    
    func updatedContact() -> CNMutableContact {
         var createContact = CNMutableContact()
        if let theContact =  detailsViewModel?.contact, let mutableCopy = theContact.mutableCopy() as? CNMutableContact {
            createContact = mutableCopy
        }
        createContact.givenName = firstNameField.nonnullText
        createContact.familyName = lastNameField.nonnullText
        createContact.phoneNumbers = [CNLabeledValue(label: "Mobile", value: CNPhoneNumber(stringValue: phoneNumberField.nonnullText))]
        createContact.emailAddresses = [CNLabeledValue(label: "Email", value: emailField.nonnullNSText)]
        let postalAd = CNMutablePostalAddress()
        postalAd.street = streetField.nonnullText
        postalAd.city = cityField.nonnullText
        postalAd.state = stateField.nonnullText
        postalAd.postalCode = zipCodeField.nonnullText
        createContact.postalAddresses = [CNLabeledValue(label: "Address", value: postalAd as CNPostalAddress)]
        return createContact
    }
    
    var isValidInput: Bool {
         return (firstNameField.text != nil) && (phoneNumberField.text != nil)
    }
    
    func invalidInputDataError() {
        DispatchQueue.main.async {
            self.displayAlertWith(title: "Invalid Data", message: "First-name and Phone-number both are mandatory input field, Please fill them continue", leftTitle: "OK", rightTitle: nil, completionHandler: nil)
        }
    }

}

enum AddEditMode {
    case add
    case edit
}
