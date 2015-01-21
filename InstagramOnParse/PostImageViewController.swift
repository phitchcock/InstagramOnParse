//
//  PostImageViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/13/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var postTextField: UITextField!


    override func viewDidLoad() {
        super.viewDidLoad()
        postTextField.layer.cornerRadius = 10.0
        postTextField.layer.borderWidth = 1
        postTextField.layer.borderColor = UIColor.blackColor().CGColor

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        imageView.image = image
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func selectImageButtonPressed(sender: AnyObject) {
        var image = UIImagePickerController()
        image.delegate = self
        image.sourceType = .PhotoLibrary
        image.allowsEditing = true

        presentViewController(image, animated: true, completion: nil)
    }

    @IBAction func postImageButtonPressed(sender: AnyObject) {
        var user = PFUser.currentUser()
        var photo = PFObject(className: "Photo")
        //var comment = PFObject(className: "Comment")
        var imageData = UIImageJPEGRepresentation(imageView.image, 0.1)
        var imageFile = PFFile(name: "postImage.jpeg", data: imageData)

        photo["user_id"] = user
        photo["image"] = imageFile
        photo["title"] = postTextField.text
        //photo["lat"] = locationManager.location.coordinate.latitude
        //photo["long"] = locationManager.location.coordinate.longitude

        //comment["user_id"] = user
        //comment["photo_id"] = photo
        //comment["comment"] = postTextField.text

        photo.saveInBackgroundWithTarget(nil, selector: nil)
        //comment.saveInBackgroundWithTarget(nil, selector: nil)
        navigationController?.popViewControllerAnimated(true)

    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {

    }

    
}
