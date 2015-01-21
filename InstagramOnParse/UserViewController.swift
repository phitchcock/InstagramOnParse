//
//  UserViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/21/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class UserViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var images: [PFObject] = []
    var user = PFUser()
    var userImage = PFFile()
    var imageFile: PFFile!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var userProfileImageView: UIImageView!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bioLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        getImages()
        usernameLabel.text = user["username"] as? String

        userProfileImageView.layer.cornerRadius = userProfileImageView.frame.size.width / 2
        userProfileImageView.clipsToBounds = true

        userImage = user["imageFile"] as PFFile
        userImage.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data: data)
                self.userProfileImageView.image = image
            }
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //followingUser()
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



    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as ImageCollectionViewCell
        let imageData = images[indexPath.row]

        imageFile = imageData["image"] as PFFile
        imageFile.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data: data)

                cell.imageView.image = image
                println("image \(image)")
            }
        }
        return cell
    }

    func getImages() {
        var query = PFQuery(className: "Photo")
        query.whereKey("user_id", equalTo: user)
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.images.removeAll()
                for object in objects {

                    self.images.append(object as PFObject)

                }
                println("getimages: \(self.images)")
                self.collectionView.reloadData()
            } else {
                println("error")
            }
        }
        
    }

}
