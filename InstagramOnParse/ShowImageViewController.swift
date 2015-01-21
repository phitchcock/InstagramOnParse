//
//  ShowImageViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/15/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class ShowImageViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {

    var comments = [PFObject]()
    var users = [PFUser]()
    var userImage = PFFile()
    var showImage: PFObject!
    var imageFile: PFFile!
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getComments()
        //println(showImage["title"])
        //imageView.image = showImage["image"] as? UIImage
        titleLabel.text = showImage["title"] as? String

        imageFile = showImage["image"] as PFFile
        imageFile.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data: data)
                self.imageView.image = image
            } else {
                println("error")
            }
        }

        refreshControl.attributedTitle = NSAttributedString(string: "Refresh")
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)

        tableView.separatorColor = UIColor.clearColor()


    }

    func refresh(sender: AnyObject) {
        getComments()
        refreshControl.endRefreshing()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as FeedTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.commentLabel.text = comment["comment"] as? String

        cell.userProfileImageView.layer.cornerRadius = cell.userProfileImageView.frame.size.width / 2
        cell.userProfileImageView.clipsToBounds = true

        userImage = user["imageFile"] as PFFile
        userImage.getDataInBackgroundWithBlock { (data: NSData!, error: NSError!) -> Void in
            if error == nil {
                let image = UIImage(data: data)
                cell.userProfileImageView.image = image
            }
        }

        return cell
    }
    
    @IBAction func addCommentButtonPressed(sender: AnyObject) {
        var comment = PFObject(className: "Comment")
        comment["comment"] = commentTextField.text
        comment["user_id"] = PFUser.currentUser()
        comment["photo_id"] = showImage
        comment.saveInBackgroundWithTarget(nil, selector: nil)
        commentTextField.text = ""
        getComments()
    }

    func getComments() {
        var query = PFQuery(className: "Comment")
        query.whereKey("photo_id", equalTo: showImage)
        query.orderByAscending("createdAt")
        query.includeKey("user_id")
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.comments.removeAll()
                self.users.removeAll()
                for object in objects {
                    let user = object["user_id"] as PFUser
                    self.comments.append(object as PFObject)
                    self.users.append(user)
                }
                 self.tableView.reloadData()
            } else {
                println("error")
            }
        }
    }

    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        view.endEditing(true)
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        commentTextField.resignFirstResponder()
        return true
    }

    func textFieldDidBeginEditing(textField: UITextField) {

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height

        if (UIScreen.mainScreen().bounds.height == 568) {

            if (textField == self.commentTextField) {

                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {

                    self.view.center = CGPointMake(theWidth/2, (theHeight/2)-40)

                    }, completion: {
                        (finished:Bool) in

                        //
                })
            }
        }
    }



    func textFieldDidEndEditing(textField: UITextField) {

        let theWidth = view.frame.size.width
        let theHeight = view.frame.size.height

        if (UIScreen.mainScreen().bounds.height == 568) {

            if (textField == self.commentTextField) {

                UIView.animateWithDuration(0.3, delay: 0, options: .CurveLinear, animations: {

                    self.view.center = CGPointMake(theWidth/2, (theHeight/2))

                    }, completion: {
                        (finished:Bool) in

                        //

                })
            }
        }
    }


}
