//
//  UserTableViewCell.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/21/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class UserTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var followButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
