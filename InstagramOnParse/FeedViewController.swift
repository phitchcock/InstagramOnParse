//
//  FeedViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/13/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var images = [PFObject]()
    var users = [PFUser]()
    var imageFile = PFFile()
    var userProfile = PFFile()
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getImages()
        //followingUsers()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }

    func refresh(sender: AnyObject) {
        getImages()
        //followingUsers()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as FeedTableViewCell
        var getUser = users[indexPath.row]
        var getImage = images[indexPath.row]
        //cell.imageView?.image = UIImage(named: "ProfileCover")
        cell.titleLabel.text = getImage["title"] as? String

        //cell.userProfileImageView.image = UIImage(named: "ProfileCover")
        cell.userProfileImageView.layer.cornerRadius = cell.userProfileImageView.frame.size.width / 2
        cell.userProfileImageView.clipsToBounds = true

        imageFile = getImage["image"] as PFFile
        imageFile.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data: data)
                cell.cellImageView.image = image
            } else {
                println("error")
            }
        }

        userProfile = getUser["imageFile"] as PFFile
        userProfile.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let userImage = UIImage(data: data)
                cell.userProfileImageView.image = userImage
            }
        }
        
        return cell
    }

    func followingUsers() {
        images = [PFObject]()
        users = [PFUser]()
        //var user = PFUser()

        var query = PFQuery(className: "Follow")
        query.whereKey("follower", equalTo: PFUser.currentUser())

        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.images.removeAll()
                self.users.removeAll()
                for object in objects {
                    let user = object["following"] as PFUser
                    var photoQuery = PFQuery(className: "Photo")
                    photoQuery.whereKey("user_id", equalTo: user)
                    photoQuery.includeKey("user_id")
                    photoQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                        if error == nil {

                            for object in objects {

                                let user = object["user_id"] as PFUser

                                self.images.append(object as PFObject)
                                self.users.append(user as PFUser)
                                
                            }
                            self.tableView.reloadData()
                            //println(self.users)
                            //println(self.images)
                        }
                    })
                }
            }
        }
    }

    func getImages() {
        images = [PFObject]()
        users = [PFUser]()

        var query = PFQuery(className: "Photo")
        query.orderByDescending("createdAt")
        query.includeKey("user_id")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {

                //self.images = objects as [PFObject]
                self.images.removeAll()
                self.users.removeAll()

                for object in objects {

                    let user = object["user_id"] as PFUser

                    self.images.append(object as PFObject)
                    self.users.append(user as PFUser)

                }
                self.tableView.reloadData()
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushShowImageSegue" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationViewController = segue.destinationViewController as ShowImageViewController
                destinationViewController.showImage = images[row]
            }
        }
    }

}
