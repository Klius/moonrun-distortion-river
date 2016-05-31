//
//  AccountCell.swift
//  platinumsupport
//
//  Created by Klius on 5/5/16.
//  Copyright © 2016 Klius. All rights reserved.
//

import UIKit

class AccountCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedImageView: UIImageView!
    var account: Account! {
        didSet {
            nameLabel.text = account.name
            selectedImageView.image = imageForSelected(account.selected)
        }
    }
    
    func imageForSelected(selected: Bool) -> UIImage? {
        var imageName = "deselected"
        if selected == true {
            imageName = "selected"
        }
        return UIImage(named: imageName)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
