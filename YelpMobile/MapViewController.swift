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
        
        if self.bizArray != nil {
            
            
            for (var i = 0; i < bizArray!.count; ++i ) {
                
                let business = self.bizArray![i] as NSDictionary
                
                var address : String = ""
            
                if let location = business["location"] as? NSDictionary {
                    if let addr = location["address"] as? NSArray? {
                        
                        if addr!.count > 0 {
                            address = (addr![0] as NSString) +  ", " + (location["city"] as NSString)
                        } else {
                            address = location["city"] as NSString
                        }
                    }
                }
                
                let name = business["name"] as String
                
                let title = String(i+1) + ". "+name
                
                dispatch_async(dispatch_get_main_queue(), {
                    
                    self.showAddressInMap(address, title: title)
                    
                })
                
            
            }
            
            
            
        }
        
    }
    
    func showAddressInMap(address: String, title: String)
    {
        var geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address, {(placemarks: [AnyObject]!, error: NSError!) -> Void in
            
            if let placemark = placemarks?[0] as? CLPlacemark {
            
                let p = MKPlacemark(placemark: placemark)
                
                let a = MKPointAnnotation()
                a.coordinate = p.coordinate
                a.title = title
                //a.subtitle = subTitle

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
