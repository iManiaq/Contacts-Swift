//
//  ContactDetailFlowCoordinator.swift
//  PrivusCall
//
//  Created by Sachin on 28/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit
import MessageUI

class ContactDetailFlowCoordinator {
    
    weak var parentController: ContactDetailController!
    
    init(parent: ContactDetailController) {
        self.parentController = parent
    }
    
     func messageAction(_ detailsViewModel: ContactDetailViewModel) {
        if (MFMessageComposeViewController.canSendText()) {
            let controller = MFMessageComposeViewController()
            controller.recipients = [detailsViewModel.numberString]
            controller.messageComposeDelegate = parentController
            parentController.present(controller, animated: true, completion: nil)
        }
    }
    
    func callAction(_ detailsViewModel: ContactDetailViewModel) {
        let mkVC =  MakeCallViewController.initViewControllerWith(contactVM: detailsViewModel)
        mkVC.modalTransitionStyle = .crossDissolve
        parentController.present(mkVC, animated: true, completion: nil)
    }

    func editContact(_ detailsViewModel: ContactDetailViewModel) {
        DispatchQueue.main.async {
            let addEditVC = AddEditContactViewController.initController(viewModel: detailsViewModel)
            addEditVC.editAndSaveContact = { [weak self](contact) in
                guard let weakSelf = self else { return }
                ContactStore.shared.updateContact(contact: contact)
                weakSelf.parentController.resetContactDetailViewModelWith(viewModel: ContactDetailViewModel(contactData: contact))
                weakSelf.parentController.editAndSaveContact?(contact)
            }
            self.parentController.navigationController?.pushViewController(addEditVC, animated: true)
        }
    }
    
}
