//
//  HomeFlowCoordinator.swift
//  PrivusCall
//
//  Created by Sachin on 20/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit

struct HomeFlowCoordinator {
    
    weak var parentController: HomeViewController!
    
     init(parent: HomeViewController) {
        self.parentController = parent
    }
    
    func didSelectContactWithViewModel(viewModel: ContactViewModel) {
        let detailsViewModel = ContactDetailViewModel(contactData: viewModel.contact)
        detailsViewModel.isPrivusContact = viewModel.isPrivusContact
        DispatchQueue.main.async {
            let detailsVC = ContactDetailController.initWith(viewModel: detailsViewModel)
            detailsVC.editAndSaveContact = { (contact) in
                self.parentController.dataSource.updateContact?(updatedContact: contact)
            }
            self.parentController.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    func addContactViewController() {
        DispatchQueue.main.async {
            let addEditVC = AddEditContactViewController.initController()
            addEditVC.createContact = { (mutableContact) in
                _ = self.parentController.dataSource.addContactWith?(contact: mutableContact)
            }
            self.parentController.navigationController?.pushViewController(addEditVC, animated: true)
        }
    }
}
