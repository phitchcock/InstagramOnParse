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
    var imageFile = PFFile()
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getImages()

        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }

    func refresh(sender: AnyObject) {
        getImages()
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
        var getImage = images[indexPath.row]
        //cell.imageView?.image = UIImage(named: "ProfileCover")
        cell.titleLabel.text = getImage["title"] as? String
        cell.usernameLabel.text = "Yep"
        cell.userProfileImageView.layer.cornerRadius = cell.cellImageView.frame.size.width / 2
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
        return cell
    }

    func getImages() {
        var query = PFQuery(className: "Photo")
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
        if segue.identifier == "pushShowImageSegue" {
            if let row = tableView.indexPathForSelectedRow()?.row {
                let destinationViewController = segue.destinationViewController as ShowImageViewController
                destinationViewController.showImage = images[row]
            }
        }
    }

}
