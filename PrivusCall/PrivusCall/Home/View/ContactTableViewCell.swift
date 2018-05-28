//
//  ContactTableViewCell.swift
//  PrivusCall
//
//  Created by Sachin on 20/05/18.
//  Copyright © 2018 Sachin. All rights reserved.
//

import UIKit

final class ContactTableViewCell: UITableViewCell {

    var viewModel: ContactCellViewModel?
    var privusIcon: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func populateViewWithViewModel(viewModel: ContactCellViewModel) {
        self.viewModel = viewModel
        self.textLabel?.attributedText = viewModel.attibutedNameString
        self.detailTextLabel?.text = viewModel.numberString
        self.imageView?.image = viewModel.image
        configurePrivusIcon()
    }
    
    func configurePrivusIcon() {
        if privusIcon == nil {
            privusIcon = UIImageView(frame: CGRect.zero)
            imageView?.addSubview(privusIcon)
            privusIcon.image = UIImage(named: "video_thumb")
            privusIcon.translatesAutoresizingMaskIntoConstraints = false
            privusIcon.bottomAnchor.constraint(equalTo: (self.imageView?.bottomAnchor)!, constant: 3).isActive = true
            privusIcon.trailingAnchor.constraint(equalTo: (self.imageView?.trailingAnchor)!, constant: 3).isActive = true
        }
        if let vModel = viewModel {
            privusIcon?.isHidden = !vModel.isPrivusContact
            timeLabel.isHidden = vModel.timeString.isEmpty
            timeLabel.text = vModel.timeString
        } else {
            privusIcon?.isHidden = true
        }
        
    }

}
