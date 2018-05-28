//
//  CallLog.swift
//  PrivusCall
//
//  Created by Sachin on 28/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import Foundation

class CallLog: NSObject, NSCoding {

    var phoneNumber: String!
    var timeStamp: Date!
    
    var nameFromPhoneNumber: String {
        return ""
    }
    
    init(phoneNumber: String, timeStamp: Date) {
        self.phoneNumber = phoneNumber
        self.timeStamp = timeStamp
    }
    
    required init(coder decoder: NSCoder) {
        self.phoneNumber = decoder.decodeObject(forKey: "phoneNumber") as? String ?? ""
        self.timeStamp = decoder.decodeObject(forKey: "timeStamp") as? Date ?? Date()
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(phoneNumber, forKey: "phoneNumber")
        coder.encode(timeStamp, forKey: "timeStamp")
    }
    
}
