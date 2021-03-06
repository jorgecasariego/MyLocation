//
//  ViewController.swift
//  MyLocation
//
//  Created by Training on 02/05/15.
//  Copyright (c) 2015 Training. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {
    
    
    var coreLocationManger = CLLocationManager()
    
    var locationManager:LocationManager!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationInfo: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        coreLocationManger.delegate = self
        
        locationManager = LocationManager.sharedInstance
        
        let authorizationCode = CLLocationManager.authorizationStatus()
        
        if authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManger.respondsToSelector("requestAlwaysAuthorization") || coreLocationManger.respondsToSelector("requestWhenInUseAuthorization"){
            if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil {
                coreLocationManger.requestAlwaysAuthorization()
            }else{
                println("No descirption provided")
            }
        }else{
            getLocation()
        }
        
        
    }
    
    func getLocation(){
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
        }
        
    }
    
    func displayLocation(location:CLLocation){
        
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        annotation.coordinate = locationPinCoord
        
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        
        locationManager.reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
            
            let address = reverseGecodeInfo?.objectForKey("formattedAddress") as! String
            self.locationInfo.text = address
            
        })
        
        
        
    }
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted{
            getLocation()
        }
    }
    
    
    @IBAction func updateLocation(sender: AnyObject) {
        getLocation()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

