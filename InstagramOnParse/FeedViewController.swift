//
//  FeedViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/13/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class FeedViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as FeedTableViewCell
        //cell.imageView?.image = UIImage(named: "ProfileCover")
        cell.titleLabel.text = "What"
        cell.usernameLabel.text = "Yep"
        cell.cellImageView.layer.cornerRadius = cell.cellImageView.frame.size.width / 2
        cell.cellImageView.clipsToBounds = true
        return cell
    }

}
