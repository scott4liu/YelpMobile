//
//  MapViewController.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/21/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var Lat: CLLocationDegrees = 37.774929
        var Log: CLLocationDegrees = -122.419416
        var latDelta : CLLocationDegrees = 0.02
        var logDelta : CLLocationDegrees = 0.02
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latDelta, logDelta)
        
        var loc : CLLocationCoordinate2D = CLLocationCoordinate2DMake(Lat, Log)
        var region : MKCoordinateRegion = MKCoordinateRegionMake(loc, span)
        
        self.mapView.setRegion(region, animated: true)
        
        
        var pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = loc;
        pointAnnotation.title = "1"
        pointAnnotation.subtitle = "Thai Food"
        
        self.mapView.addAnnotation(pointAnnotation)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
