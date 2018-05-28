//
//  ContactDetailController.swift
//  PrivusCall
//
//  Created by Sachin on 20/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit
import MessageUI

final class ContactDetailController: UITableViewController {
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var streetAddressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    @IBOutlet weak var privusIcon: UIImageView!
    @IBOutlet weak var callIcon: UIButton!
    
    var flowCoordinator: ContactDetailFlowCoordinator!
    var detailsViewModel: ContactDetailViewModel!
    var editAndSaveContact: ContactAddAction?
    
    class func initWith(viewModel: ContactDetailViewModel) -> ContactDetailController{
        let vc = UIStoryboard.viewController(fromStoryboardName: Storyboard.main, storyBoardIdentifier: ContactDetailController.identifier) as! ContactDetailController
        vc.detailsViewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
    
    func configureView() {
        configureNavigationItems()

        profilePictureView.addShadow()
        profilePictureView.image = detailsViewModel.largeImage
        privusIcon.isHidden = !detailsViewModel.isPrivusContact
        callIcon.isEnabled = detailsViewModel.isPrivusContact
        nameLabel.text = detailsViewModel.fullName

        phoneNumberLabel.text = detailsViewModel.numberString
        emailLabel.text = detailsViewModel.emailString

        streetAddressLabel.text = detailsViewModel.streetAddressString
        cityLabel.text = detailsViewModel.cityString
        stateLabel.text = detailsViewModel.state
        zipCodeLabel.text = detailsViewModel.zipCode
    }
    
    func resetContactDetailViewModelWith(viewModel: ContactDetailViewModel) {
        detailsViewModel = viewModel
        DispatchQueue.main.async {
            self.configureView()
        }
    }
    
    func configureNavigationItems() {
        flowCoordinator = ContactDetailFlowCoordinator(parent: self)
        let rightButton =  UIBarButtonItem(title: "Edit", style: .done, target: self, action: #selector(editContact))
        navigationItem.rightBarButtonItem = rightButton
    }
    
    @objc func editContact() {
        flowCoordinator.editContact(detailsViewModel)
    }
    
    @IBAction func messageAction(_ sender: Any) {
        flowCoordinator.messageAction(detailsViewModel)
    }
    
    @IBAction func callAction(_ sender: Any) {
        flowCoordinator.callAction(detailsViewModel)
    }
}

extension ContactDetailController: MFMessageComposeViewControllerDelegate {
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController,
                                      didFinishWith result: MessageComposeResult) {
            self.dismiss(animated: true, completion: nil)
    }
}
