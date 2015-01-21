//
//  UsersViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/13/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var one = PFUser()
    var users: [PFUser] = []
    var following: [Bool] = []
    var refreshControl = UIRefreshControl()
    var profileImage: PFFile!

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var addUser = PFUser()
        //users.append(addUser)'
        //users = [one]
        getUsers()

        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UserTableViewCell

        cell.profileImageView.layer.cornerRadius = cell.profileImageView.frame.size.width / 2
        cell.profileImageView.clipsToBounds = true

        var user = users[indexPath.row]
        cell.nameLabel.text = user.username

        profileImage = user["imageFile"] as PFFile
        profileImage.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data: data)
                cell.profileImageView.image = image
            }
        }
        
        return cell
    }
    /*
    @IBAction func followUser(sender: AnyObject) {

        var user = PFUser()
        var queryUser = PFUser.query()
        queryUser.whereKey("username", equalTo: )

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





            /* else
            var follow = PFObject(className: "Follow")
            follow["follower"] = PFUser.currentUser()
            follow["following"] = users[indexPath.row]
            follow.saveInBackgroundWithTarget(nil, selector: nil)
            */


    }
    */
    /*
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell: UITableViewCell = tableView.cellForRowAtIndexPath(indexPath)!
        var user = users[indexPath.row]
        if cell.accessoryType == .Checkmark {
            cell.accessoryType = .None

            var query = PFQuery(className:"Follow")
            query.whereKey("follower", equalTo: PFUser.currentUser())
            query.whereKey("following", equalTo: user)
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    for object in objects {
                        object.deleteInBackgroundWithTarget(nil, selector: nil)
                    }
                } else {
                    println(error)
                }
            }

        } else {
            cell.accessoryType = .Checkmark
            var follow = PFObject(className: "Follow")
            follow["follower"] = PFUser.currentUser()
            follow["following"] = users[indexPath.row]
            follow.saveInBackgroundWithTarget(nil, selector: nil)
        }
    }
    */

    func refresh(sender: AnyObject) {
        getUsers()
    }

    func getUsers1() {
        var query = PFUser.query()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            self.users.removeAll(keepCapacity: true)
            for object in objects {
                var user: PFUser = object as PFUser
                var isFollowing = Bool()
                if user.username != PFUser.currentUser().username {

                    self.users.append(user)
                    isFollowing = false

                    var query = PFQuery(className:"Follow")
                    query.whereKey("follower", equalTo: PFUser.currentUser())
                    query.whereKey("following", equalTo: user)
                    query.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {
                            for object in objects {
                                isFollowing = true
                            }
                            self.following.append(isFollowing)
                            self.tableView.reloadData()
                        } else {
                            println(error)
                        }
                        self.refreshControl.endRefreshing()
                    }
                }
            }
        }
    }

    func getUsers() {
        var query = PFUser.query()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            self.users.removeAll()

            for object in objects {
                var user = object as PFUser
                if user.username != PFUser.currentUser().username {
                    self.users.append(user)
                }
            }
            self.tableView.reloadData()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImagesSegue" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationViewController = segue.destinationViewController as ImagesViewController
                destinationViewController.user = users[row]
            }
        }

        if segue.identifier == "showUserSegue" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationViewController = segue.destinationViewController as UserViewController
                destinationViewController.user = users[row]
            }
        }
    }

}
