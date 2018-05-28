//
//  HistoryStore.swift
//  PrivusCall
//
//  Created by Sachin on 28/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import Foundation

typealias HistoryFetchCompletion = (_ historyRecords: [CallLog], _ error: Error?) -> Void

protocol HistoryStoreInteractor {
    func fetchAllRecentHistoryRecords(_ completion: HistoryFetchCompletion)
    func addHistoryRecord(_ historyRecord: CallLog)
    @discardableResult func deleteHistoryRecord(_ historyRecord: CallLog) -> Bool
}

class HistoryStore {
    
    static let shared = HistoryStore()
    
    var historyCollection = [CallLog]()
    var persistor = PersistInteractor()
    
    private init() { }
    
    func fetchHistoryRecords(_ completion: HistoryFetchCompletion) {
        persistor.fetchAllRecentHistoryRecords { [weak self](records, error) in
            guard let weakSelf = self else { return }
            weakSelf.historyCollection = records
            completion(weakSelf.historyCollection, nil)
        }
    }
    
    func addHistoryRecord(_ historyRecord: CallLog) {
        persistor.addHistoryRecord(historyRecord)
    }
    
    func deleteHistoryRecord(_ historyRecord: CallLog) -> Bool {
        return persistor.deleteHistoryRecord(historyRecord)
    }
    
    
}
