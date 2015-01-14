//
//  ImagesViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/13/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class ImagesViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var images: [PFObject] = []
    var imageFile = PFFile()
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getImages()
        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        collectionView.addSubview(refreshControl)
        collectionView.alwaysBounceVertical = true
    }

    func refresh(sender: AnyObject) {
        getImages()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
            } else {
                println("error")
            }
        }
        return cell
    }

    func getImages() {
        var query = PFQuery(className: "Photo")
        query.whereKey("user_id", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.images.removeAll()
                for object in objects {
                    self.images.append(object as PFObject)
                    self.collectionView.reloadData()
                }
            } else {
                println("error")
            }
        }

    }

    

}