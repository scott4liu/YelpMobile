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
    }
    
    func showBusinessesInMap() {
        var address = "699 8th Street, San Francisco, CA  94103"
        showAddressInMap(address)
        
        address = "160 Spear St #1750, San Francisco, CA 94105"
        showAddressInMap(address)
        
    }
    
    func showAddressInMap(address: String)
    {
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if let placemark = placemarks?[0] as? CLPlacemark {
            
                let p = MKPlacemark(placemark: placemark)
                
                let a = MKPointAnnotation()
                a.coordinate = p.coordinate
                a.title = "1"
                a.subtitle = "Thai Food"

                self.mapView.addAnnotation(a)
            }
        })
        
    }
    
    func initMap()
    {
        //default to SF for now
        var center_latitude: CLLocationDegrees = 37.774929
        var center_longitude: CLLocationDegrees = -122.419416
        var center_location : CLLocationCoordinate2D = CLLocationCoordinate2DMake(center_latitude, center_longitude)
        
        var latitudeDelta : CLLocationDegrees = 0.1
        var longitudeDelta : CLLocationDegrees = 0.1
        var span: MKCoordinateSpan = MKCoordinateSpanMake(latitudeDelta, longitudeDelta)
        
        var region : MKCoordinateRegion = MKCoordinateRegionMake(center_location, span)
        
        self.mapView.setRegion(region, animated: true)
        
    }
   

}
