//
//  HistoryDataSource.swift
//  PrivusCall
//
//  Created by Sachin on 28/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import Foundation
import Contacts

@objc protocol DataSource: class {
    func titleForHeaderInSection(section: Int) -> String?
    func sectionIndexTitles() -> [String]?
    func numberOfSections() -> Int
    func numberOfRowsInSection(section: Int) -> Int
    func viewModelForRowAt(indexPath: IndexPath) -> ContactCellViewModel
    var dataCompletion: DataFetchCompletion? { get set }
    
    @objc optional func requestAccesIfNeeded()
    @discardableResult @objc optional func addContactWith(contact: CNMutableContact) -> CNContact?
    @objc optional func deleteContactAtIndexPath(indexPath: IndexPath)
    @objc optional func updateContact(updatedContact: CNContact)
}

class HistoryDataSource: DataSource {
    
    fileprivate var results: [CallLog] = []
    fileprivate var historyViewModels: [HistoryViewModel] = []
    var dataCompletion: DataFetchCompletion?

    init() {
        fetchHistoryRecords()
        NotificationCenter.default.addObserver(self, selector: #selector(fetchHistoryRecords), name: NSNotification.Name.init(makeCallDataUpdate), object: nil)
    }

    func titleForHeaderInSection(section: Int) -> String? {
        return nil
    }
    
    func sectionIndexTitles() -> [String]? {
        return nil
    }
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return historyViewModels.count
    }
    
    func viewModelForRowAt(indexPath: IndexPath) -> ContactCellViewModel {
        return historyViewModels[indexPath.item]
    }
    
    @objc func fetchHistoryRecords() {
        HistoryStore.shared.fetchHistoryRecords( { [weak self](records, error) in
            guard let weakSelf = self else { return }
            weakSelf.results = records
            weakSelf.historyViewModels.removeAll()
            for hist in weakSelf.results {
                weakSelf.historyViewModels.append(HistoryViewModel(callLogData: hist))
            }
            weakSelf.dataCompletion?(true)
        })
    }

}
