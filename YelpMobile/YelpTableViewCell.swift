//
//  YelpTableViewCell.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/18/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit

class YelpTableViewCell: UITableViewCell {

    @IBOutlet weak var reviewsLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var ratingImgView: UIImageView!
    @IBOutlet weak var bizImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
