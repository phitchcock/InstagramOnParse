//
//  FeedTableViewCell.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/13/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class FeedTableViewCell: UITableViewCell {


    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userProfileImageView: UIImageView!




    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
