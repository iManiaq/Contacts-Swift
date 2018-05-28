//
//  HomeDataSource.swift
//  PrivusCall
//
//  Created by Sachin on 19/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import Foundation
import Contacts

public typealias DataFetchCompletion = (_ needsReload: Bool) -> Void

final class HomeDataSource: DataSource {

    fileprivate var results: [CNContact] = []
    fileprivate var allResults: [CNContact] = []
    fileprivate var privousResults: [CNContact] = []
    fileprivate var sectionedContactsViewModel = [[ContactViewModel]]()
    fileprivate var uniqueFirstLetters = [String]()
    fileprivate var selectedContactGroup: ContactGroups = .all
    
    var dataCompletion: DataFetchCompletion?
    
    func requestAccesIfNeeded() {
        ContactStore.shared.requestAcces { [weak self](success, error) in
            guard let weakSelf = self else { return }
            if success {
                weakSelf.fetchContacts()
            }
        }
    }
    
    func titleForHeaderInSection(section: Int) -> String? {
        return uniqueFirstLetters[section]
    }
    
    func sectionIndexTitles() -> [String]? {
        return ListView.sectionTitles
    }
    
    func numberOfSections() -> Int {
        return sectionedContactsViewModel.count
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return sectionedContactsViewModel[section].count
    }
    
    func viewModelForRowAt(indexPath: IndexPath) -> ContactCellViewModel{
        let viewModel = sectionedContactsViewModel[indexPath.section][indexPath.row]
        viewModel.isPrivusContact = privousResults.contains(viewModel.contact)
        return viewModel
    }
    
    @discardableResult func addContactWith(contact: CNMutableContact) -> CNContact? {
        var addedCon: CNContact?
        if let theContact =  ContactStore.shared.addContact(contact: contact) {
            allResults.append(theContact)
            privousResults.append(theContact)
            addedCon = theContact
            setSelectedContactGroup(group: selectedContactGroup)
        }
        return addedCon
    }
    
    func deleteContactAtIndexPath(indexPath: IndexPath) {
         let viewModel = sectionedContactsViewModel[indexPath.section][indexPath.row]
        let contactToDelete = viewModel.contact
        allResults = allResults.filter { (contact) -> Bool in
            contactToDelete != contact
        }
        privousResults = privousResults.filter { (contact) -> Bool in
            contactToDelete != contact
        }
        ContactStore.shared.deleteContact(contact: contactToDelete)
        setSelectedContactGroup(group: selectedContactGroup)
    }
    
    func updateContact(updatedContact: CNContact) {
        allResults = allResults.map({ (contact) -> CNContact in
             return (updatedContact.identifier == contact.identifier) ? updatedContact : contact
        })
        privousResults = privousResults.map({ (contact) -> CNContact in
            return (updatedContact.identifier == contact.identifier) ? updatedContact : contact
        })
        setSelectedContactGroup(group: selectedContactGroup)
    }
    
    fileprivate  func fetchContacts() {
        ContactStore.shared.fetchContactsWithCompletion { [weak self](results, error) in
            guard let weakSelf = self else { return }
            weakSelf.allResults.append(contentsOf: results)
            weakSelf.results = weakSelf.allResults
            weakSelf.updateDataSource()
        }
        ContactStore.shared.fetchContactsWithCompletion(privousOnly: true) { [weak self](results, error) in
            guard let weakSelf = self else { return }
            weakSelf.privousResults.append(contentsOf: results)
        }
    }
    
    private func updateDataSource() {
        setUniqueFirstLetters()
        setSectionedContacts()
        dataCompletion?(true)
    }
    
    func setSelectedContactGroup(group: ContactGroups) {
        selectedContactGroup = group
        switch group {
        case .all:
            results = allResults
            break
        case .privusOnly:
            results = privousResults
            break
        }
        updateDataSource()
        dataCompletion?(true)
    }
    
}

extension HomeDataSource {
    
    func setUniqueFirstLetters() {
        let firstLetters = results.map { $0.firstLetterForSort }
        let uniqueFirstLettersData = Set(firstLetters)
        uniqueFirstLetters = Array(uniqueFirstLettersData).sorted()
    }
    
    func setSectionedContacts() {
        sectionedContactsViewModel = uniqueFirstLetters.map { firstLetter in
            let filteredContact = results.flatMap{ ($0.firstLetterForSort == firstLetter) ?  ContactViewModel(contactData: $0) : nil }
            return filteredContact.sorted(by: { $0.firstName < $1.firstName })
        }
    }
    
}

extension CNContact {
    var firstLetterForSort: String {
        return String(givenName.first!).uppercased()
    }
}

enum HomeViewOption {
    case history
    case contacts
    
    var title : String {
        switch self {
        case .history: return "History"
        case .contacts: return "Contacts"
        }
    }
}

enum ContactGroups {
    case all
    case privusOnly
    
    static func groupFromIndex(index: Int) -> ContactGroups {
        return index == 0 ?  .all : .privusOnly
    }
    
    var index : Int {
        switch self {
        case .all: return 0
        case .privusOnly: return 1
        }
    }
    
    var title : String {
        switch self {
        case .all: return "All"
        case .privusOnly: return "VOIP"
        }
    }
}
