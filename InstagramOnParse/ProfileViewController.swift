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
    var images = [PFObject]()
    var imageFile = PFFile()
    var userCellImage = PFFile()
    var cellImageFile = PFFile()
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getImages()
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

        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        tableView.separatorColor = UIColor.clearColor()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func refresh(sender: AnyObject) {
        getImages()
        refreshControl.endRefreshing()
    }


    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as FeedTableViewCell
        let getImage = images[indexPath.row]
        cell.titleLabel.text = getImage["title"] as? String

        //cell.userProfileImageView.image = UIImage(named: "ProfileCover")
        cell.userProfileImageView.layer.cornerRadius = cell.userProfileImageView.frame.size.width / 2
        cell.userProfileImageView.clipsToBounds = true

        cellImageFile = getImage["image"] as PFFile
        cellImageFile.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error != nil {
                println("error")
            } else {
                //println(data)
                let image = UIImage(data: data)
                cell.cellImageView.image = image
            }
        }

        userCellImage = PFUser.currentUser()["imageFile"] as PFFile
        userCellImage.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data: data)
                cell.userProfileImageView.image = image
            } else {
                println("error")
            }
        }

        return cell

    }

    func getImages() {
        var query = PFQuery(className: "Photo")
        query.whereKey("user_id", equalTo: PFUser.currentUser())
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.images.removeAll()
                for object in objects {
                    self.images.append(object as PFObject)

                }
                self.tableView.reloadData()

            } else {
                println("error")
            }
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showImageSegue" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationViewController = segue.destinationViewController as ShowImageViewController
                destinationViewController.showImage = images[row]
            }
        }
    }

    @IBAction func logoutButtonPressed(sender: AnyObject) {
        PFUser.logOut()

        performSegueWithIdentifier("logoutSegue", sender: self)
    }
    

}
