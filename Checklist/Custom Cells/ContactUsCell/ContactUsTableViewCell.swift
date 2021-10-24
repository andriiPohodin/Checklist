//
//  ContactUsTableViewCell.swift
//  Checklist
//
//  Created by Andrii Pohodin on 14.10.2021.
//

import UIKit

class ContactUsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var contactUsLabel: UILabel!
    @IBOutlet weak var contactUsBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
