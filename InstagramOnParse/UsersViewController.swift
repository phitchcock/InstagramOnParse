//
//  UsersViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/13/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class UsersViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var users: [PFUser] = []
    var following: [Bool] = []
    var refreshControl = UIRefreshControl()

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //var addUser = PFUser()
        //users.append(addUser)
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
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        if following.count > indexPath.row {
            if following[indexPath.row] {
                cell.accessoryType = .Checkmark
            }
        }

        var user = users[indexPath.row]
        cell.textLabel?.text = user.username
        return cell
    }

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

    func refresh(sender: AnyObject) {
        getUsers()
    }

    func getUsers() {
        var query = PFUser.query()
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            self.users.removeAll(keepCapacity: true)
            for object in objects {
                var user: PFUser = object as PFUser
                var isFollowing = Bool()
                if user.username != PFUser.currentUser().username {

                    self.users.append(user)
                    //isFollowing = false

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

}
