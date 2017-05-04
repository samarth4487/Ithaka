//
//  MapViewController.swift
//  Ithaka
//
//  Created by Samarth Paboowal on 04/05/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        requestLocationAccess()
        addAnnotations()
        
        let latitude:CLLocationDegrees = 10.4930
        let longitude:CLLocationDegrees = 99.1800
        let latDelta:CLLocationDegrees = 4
        let lonDelta:CLLocationDegrees = 4
        let span = MKCoordinateSpanMake(latDelta, lonDelta)
        let location = CLLocationCoordinate2DMake(latitude, longitude)
        let region = MKCoordinateRegionMake(location, span)
        
        mapView.setRegion(region, animated: false)
    }
    
    func requestLocationAccess() {
        
        let status = CLLocationManager.authorizationStatus()
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return
            
        case .denied, .restricted:
            print("location access denied")
            
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func addAnnotations() {
        
        mapView.delegate = self
        let places = Place.getPlaces()
        mapView.addAnnotations(places as! [MKAnnotation])
        
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
            
        else {
            let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
            
            let pinImage = UIImage(named: "pin_light")
            let size = CGSize(width: 30, height: 50)
            UIGraphicsBeginImageContext(size)
            pinImage!.draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            annotationView.image = resizedImage
            
            return annotationView
        }
    }

}
