//
//  MapViewController.swift
//  InstagramOnParse
//
//  Created by Peter Hitchcock on 1/16/15.
//  Copyright (c) 2015 Peter Hitchcock. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {

    var images: [PFObject] = []
    var locationManager: CLLocationManager!

    @IBOutlet weak var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 100.0
        locationManager.startUpdatingLocation()
        locationManager.requestAlwaysAuthorization()
    }

    override func viewWillAppear(animated: Bool) {
        getImages()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
    }

    func getImages() {
        var query = PFQuery(className: "Photo")
        query.whereKey("user_id", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock { (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.images.removeAll()
                for object in objects {
                    self.images.append(object as PFObject)
                    var lat = object["lat"] as Double
                    var long = object["long"] as Double
                    let location = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    let span = MKCoordinateSpanMake(0.05, 0.05)
                    let region = MKCoordinateRegionMake(location, span)
                    self.mapView.setRegion(region, animated: true)
                    let annotation = MKPointAnnotation()
                    annotation.setCoordinate(location)
                    annotation.title = object["title"] as String
                    self.mapView.addAnnotation(annotation)
                }
            } else {
                println("error")
            }
        }
    }
}
