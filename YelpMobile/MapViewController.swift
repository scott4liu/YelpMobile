//
//  MapViewController.swift
//  YelpMobile
//
//  Created by Scott Liu on 9/21/14.
//  Copyright (c) 2014 Scott. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var bizArray : NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initMap();
        showBusinessesInMap();
        
       /*
        var pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = loc;
        pointAnnotation.title = "1"
        pointAnnotation.subtitle = "Thai Food"
        
        self.mapView.addAnnotation(pointAnnotation)
       */
        // Do any additional setup after loading the view.
    }
    
    func showBusinessesInMap()
    {
        var address = "699 8th Street, San Francisco, CA  94103"
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            //println(placemarks)
            //println(error)
            
            if let placemark = placemarks?[0] as? CLPlacemark {
                println("placemark: ")
                println(placemark)
           
                let a = MKPlacemark(placemark: placemark)
                self.mapView.addAnnotation(a)
                
                /*
                let loc = placemark.location
                
                println(loc.coordinate.latitude)
                println(loc.coordinate.longitude)
                
                let loc2D = CLLocationCoordinate2DMake(loc.coordinate.latitude, loc.coordinate.longitude)
                
                var pointAnnotation = MKPointAnnotation()
                pointAnnotation.coordinate = loc2D;
                pointAnnotation.title = "1"
                pointAnnotation.subtitle = "Thai Food"
                
                self.mapView.addAnnotation(pointAnnotation)
                */
            }
        })
        
    }
    
    func initMap()
    {
        //default to SF for now
        var center_latitude: CLLocationDegrees = 37.774929
        var center_longitude: CLLocationDegrees = -122.419416
        var center_location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(center_latitude, center_longitude)
        
        var latitudeDelta : CLLocationDegrees = 0.05
        var longitudeDelta : CLLocationDegrees = 0.05
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        
        var region : MKCoordinateRegion = MKCoordinateRegionMake(center_location, span)
        
        self.mapView.setRegion(region, animated: true)
        
    }
   

}
