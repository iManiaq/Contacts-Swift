//
//  ContactStore.swift
//  PrivusCall
//
//  Created by Sachin on 22/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import Foundation
import Contacts

public typealias DataCompletion = (_ conatcts: [CNContact], _ error: Error?) -> Void
public typealias AuthCompletion = (_ sucess: Bool, _ error: Error?) -> Void

let privusCallVOIPGroup = "PrivusVOIP"

class ContactStore {
    
    static let shared = ContactStore()
    let store = CNContactStore()
    var privusVOIPGroup: CNGroup?
    var results: [CNContact] = []

    private init(){ }
    
    var privusVOIPGroupIdentifier: String {
        var identifier = ""
        if let priIdent = privusVOIPGroup?.identifier  {
            identifier = priIdent
        }
        return identifier
    }
    
    func requestAcces(completion: AuthCompletion?) {
         store.requestAccess(for: .contacts) { [weak self](sucess, error) in
            guard let weakSelf = self else { return }
            weakSelf.isAuthorized()
            weakSelf.getPrivusCallVOIPGroup()
            completion?(sucess, error)
        }
    }
    
     @discardableResult func isAuthorized() -> Bool{
        return CNContactStore.authorizationStatus(for: .contacts) == .authorized
    }
    
    func fetchContactsWithCompletion(privousOnly: Bool = false ,completion: DataCompletion?) {
        let fetchRequest = CNContactFetchRequest(keysToFetch: [CNContactGivenNameKey as CNKeyDescriptor, CNContactFamilyNameKey as CNKeyDescriptor, CNContactMiddleNameKey as CNKeyDescriptor, CNContactEmailAddressesKey as CNKeyDescriptor,CNContactPhoneNumbersKey as CNKeyDescriptor, CNContactImageDataAvailableKey as CNKeyDescriptor, CNContactThumbnailImageDataKey as CNKeyDescriptor, CNContactPostalAddressesKey as CNKeyDescriptor])
        fetchRequest.sortOrder = CNContactSortOrder.userDefault
        if privousOnly {
            fetchRequest.predicate = CNContact.predicateForContactsInGroup(withIdentifier: privusVOIPGroupIdentifier)
        }
        do {
            var resultsSet = [CNContact]()
            try store.enumerateContacts(with: fetchRequest, usingBlock: { (contact, stop) -> Void in
                 resultsSet.append(contact)
            })
            if !privousOnly { results = resultsSet }
            completion?(resultsSet, nil)
        }
        catch let error as NSError {
            print(error.localizedDescription)
            completion?([], error)
        }
    }
    
    @discardableResult func addContact(contact: CNMutableContact) -> CNContact? {
        var createdContact: CNContact?
        if let privusVOIP = privusVOIPGroup {
            let saveRequest: CNSaveRequest = CNSaveRequest()
            saveRequest.addMember(contact, to: privusVOIP)
            saveRequest.add(contact, toContainerWithIdentifier: nil)
            do {
                try ContactStore.shared.store.execute(saveRequest)
                createdContact = contact
                results.append(contact)
            }
            catch {
                let err = error as! CNError
                print("createContact : Failure \(err)")
            }
        }
        return createdContact
    }
    
    func deleteContact(contact: CNContact) {
        let contactToDelete:CNMutableContact = contact.mutableCopy() as! CNMutableContact
        let saveRequest: CNSaveRequest = CNSaveRequest()
        saveRequest.delete(contactToDelete)
        do {
            try ContactStore.shared.store.execute(saveRequest)
            results = results.filter({ (contactItem) -> Bool in
                return contactItem.identifier != contact.identifier
            })
        }
        catch {
            let err = error as! CNError
            print("deleteContact : Failure \(err)")
        }
    }
    
    func updateContact(contact: CNMutableContact) {
        let saveRequest: CNSaveRequest = CNSaveRequest()
        saveRequest.update(contact)
        do {
            try ContactStore.shared.store.execute(saveRequest)
            results = results.map({ (contactItem) -> CNContact in
                return (contactItem.identifier == contact.identifier) ? contact : contactItem
            })
        }
        catch {
            let err = error as! CNError
            print("updateContact : Failure \(err)")
        }
    }
    
    func nameFromNumber(number: String) -> String {
        var name = number
        let contact = results.filter { (item) -> Bool in
            return item.phoneNumbers.first?.value.stringValue == number
        }
        name = ((contact.first?.givenName ?? "")  + (contact.first?.familyName ?? ""))
        return name.isEmpty ? number : name
    }
    
    func getPrivusCallVOIPGroup() {
        if self.isAuthorized() {
            do {
                let groups: [CNGroup] = try self.store.groups(matching: nil)
                let privusVOIPGroups = groups.filter({ (group) -> Bool in
                    return group.name == privusCallVOIPGroup
                })
                if let privus = privusVOIPGroups.first {
                    privusVOIPGroup = privus
                } else {
                    createPrivusCallVOIPGroup()
                }
            }
            catch {
                let err = error as! CNError
                print("getPrivusCallVOIPGroup : Failure \(err)")
            }
        }
    }
    
    func createPrivusCallVOIPGroup() {
        let saveRequest = CNSaveRequest()
        let group = CNMutableGroup()
        group.name = privusCallVOIPGroup
        saveRequest.add(group, toContainerWithIdentifier: nil)
        do {
            try store.execute(saveRequest)
            privusVOIPGroup = group
        }
        catch {
            let err = error as! CNError
            print("Error saving group:\n\(err)")
        }
    }
    
  
}
