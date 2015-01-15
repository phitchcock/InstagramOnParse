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

    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getImages()
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

}
