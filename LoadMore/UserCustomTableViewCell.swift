//
//  UserCustomTableViewCell.swift
//  LoadMore
//
//  Created by Ayyanchira, Akshay Murari on 11/30/17.
//  Copyright © 2017 group2. All rights reserved.
//

import UIKit

class UserCustomTableViewCell: UITableViewCell {

    
    
    
    @IBOutlet weak var firstNameLabel: UILabel!
    @IBOutlet weak var lastNameLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var ipaddressLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
