//
//  UserViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/21/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {

    var user: PFUser!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        usernameLabel.text = user["username"] as? String
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        followingUser()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func followUser(sender: AnyObject) {
        var follow = PFObject(className: "Follow")
        follow["follower"] = PFUser.currentUser()
        follow["following"] = user
        follow.saveInBackgroundWithBlock(nil)
        //followButton.hidden = true
    }

    @IBAction func unfollowButton(sender: AnyObject) {

        var query = PFQuery(className:"Follow")
        query.whereKey("follower", equalTo: PFUser.currentUser())
        query.whereKey("following", equalTo: user)
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    object.deleteInBackgroundWithTarget(nil, selector: nil)
                }

            }
        }
    }

    func followingUser() {
        var query = PFQuery(className: "Follow")
        query.whereKey("follower", equalTo: PFUser.currentUser())
        query.whereKey("following", equalTo: user)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                for object in objects {
                    if object["follower"] as PFUser == PFUser.currentUser() && object["following"] as PFUser == self.user {
                        self.followButton.enabled = false
                        self.followButton.setTitle("Following", forState: UIControlState.Disabled)
                    }
                }

            }
        }
    }
}
