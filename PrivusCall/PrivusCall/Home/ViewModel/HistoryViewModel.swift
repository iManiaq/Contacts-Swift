//
//  HistoryViewModel.swift
//  PrivusCall
//
//  Created by Sachin on 28/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit
import Contacts

@objc protocol ContactCellViewModel {
    var numberString: String { get }
    var timeString: String { get }
    var attibutedNameString: NSAttributedString { get }
    var image: UIImage { get }
    var isPrivusContact: Bool {get set}
}

class HistoryViewModel: ContactCellViewModel {
    
    internal let callLog: CallLog
    let numberString: String = ""
    var timeString: String = ""
    let image: UIImage = UIImage(named: "callog")!

    var isPrivusContact: Bool = false

    init(callLogData: CallLog) {
        callLog = callLogData
        calTimeString()
    }
    
    var attibutedNameString: NSAttributedString  {
        return NSMutableAttributedString(string: ContactStore.shared.nameFromNumber(number: callLog.phoneNumber),
                                         attributes: [ NSAttributedStringKey.font: UIFont.systemFont(ofSize: 17.0,
                                                                                                     weight: UIFont.Weight.semibold)])
    }
    
    
    func calTimeString() {
        timeString = callLog.timeStamp.timeAgoSinceNow
    }


}
