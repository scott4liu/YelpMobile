//
//  FilterTableViewCell.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/21/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    @IBOutlet weak var itemNameLabel:UILabel!
    
 
    @IBOutlet weak var itemSwitch: UISwitch!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
