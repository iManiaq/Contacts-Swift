//
//  PersistInteractor.swift
//  PrivusCall
//
//  Created by Sachin on 28/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import Foundation

let historyRecordsKey = "history.Records.PrivusCall"

struct PersistInteractor: HistoryStoreInteractor {
    
    // Can connect to coreData / any other DB interface
    func fetchAllRecentHistoryRecords(_ completion: ([CallLog], Error?) -> Void) {
        var records = [CallLog]()
        if let dataArray = UserDefaults.standard.object(forKey: historyRecordsKey) as? [Data] {
            records = dataArray.flatMap({ (data) -> CallLog? in
                return NSKeyedUnarchiver.unarchiveObject(with: data) as? CallLog
            })
        }
        completion(records, nil)
    }
        
    func addHistoryRecord(_ historyRecord: CallLog) {
        var records = HistoryStore.shared.historyCollection
        records.append(historyRecord)
        let data = records.map { (callLog) -> Data in
            NSKeyedArchiver.archivedData(withRootObject: callLog)
        }
        UserDefaults.standard.set(data, forKey: historyRecordsKey)
        UserDefaults.standard.synchronize()
    }
    
    func deleteHistoryRecord(_ historyRecord: CallLog) -> Bool {
        var deleted = false
        var allRecords = HistoryStore.shared.historyCollection
        if let index = allRecords.index(of: historyRecord) {
            allRecords.remove(at: index)
            deleted = true
        }
        let data = allRecords.map { (callLog) -> Data in
            NSKeyedArchiver.archivedData(withRootObject: callLog)
        }
        UserDefaults.standard.set(data, forKey: historyRecordsKey)
        UserDefaults.standard.synchronize()
        return deleted
    }
}
