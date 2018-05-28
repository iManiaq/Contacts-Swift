//
//  MakeCallViewController.swift
//  PrivusCall
//
//  Created by Sachin on 28/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit
import Contacts

let makeCallDataUpdate = "make.Call.Data.Update.notif"

class MakeCallViewController: UIViewController {

    @IBOutlet weak var callBottomBar: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var contactViewModel: ContactDetailViewModel!

    class func initViewControllerWith(contactVM: ContactDetailViewModel) -> MakeCallViewController{
        let vc = UIStoryboard.viewController(fromStoryboardName: Storyboard.main, storyBoardIdentifier: MakeCallViewController.identifier) as! MakeCallViewController
        vc.contactViewModel = contactVM
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func configure() {
        nameLabel.text = contactViewModel.fullName
        callBottomBar.addDarkShadow()
        addCallLog()
    }
    
    func addCallLog() {
        HistoryStore.shared.addHistoryRecord(CallLog(phoneNumber: contactViewModel.numberString, timeStamp: Date()))
        NotificationCenter.default.post(name: NSNotification.Name.init(makeCallDataUpdate), object: nil)
    }

    @IBAction func disconnectCall(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
