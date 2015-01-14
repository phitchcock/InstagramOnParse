//
//  ProfileViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/14/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    //var user = PFUser.currentUser()
    var imageFile: PFFile!
    var cellImageFile: PFFile!

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameLabel.text = PFUser.currentUser().username
        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.width / 2
        userProfileImageView.layer.borderWidth = 1
        userProfileImageView.clipsToBounds = true 
        userProfileImageView.layer.borderColor = UIColor.blackColor().CGColor

        imageFile = PFUser.currentUser()["imageFile"] as PFFile
        imageFile.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data: data)
                self.userProfileImageView.image = image
                self.backgroundImageView.image = image
            } else {
                println("error")
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as FeedTableViewCell

        cell.titleLabel.text = "What"
        cell.usernameLabel.text = "Yep"
        cell.userProfileImageView.layer.cornerRadius = cell.cellImageView.frame.size.width / 2
        cell.userProfileImageView.clipsToBounds = true
        cellImageFile = PFUser.currentUser()["imageFile"] as PFFile
        cellImageFile.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error != nil {
                println("error")
            } else {
                let image = UIImage(data: data)
                cell.userProfileImageView.image = image
            }
        }
        return cell

    }

    func getUser() {

    }
    

}
