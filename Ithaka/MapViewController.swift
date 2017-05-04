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
    var resizedImageLight: UIImage?
    var resizedImageDark: UIImage?
    let bottomView = BottomView()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resizeImages()
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
    
    func resizeImages() {
        
        let pinImageLight = UIImage(named: "pin_light")
        let sizeLight = CGSize(width: 30, height: 50)
        UIGraphicsBeginImageContext(sizeLight)
        pinImageLight!.draw(in: CGRect(x: 0, y: 0, width: sizeLight.width, height: sizeLight.height))
        resizedImageLight = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        let pinImageDark = UIImage(named: "pin_dark")
        let sizeDark = CGSize(width: 30, height: 50)
        UIGraphicsBeginImageContext(sizeDark)
        pinImageDark!.draw(in: CGRect(x: 0, y: 0, width: sizeDark.width, height: sizeDark.height))
        resizedImageDark = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
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
            
            annotationView.image = resizedImageLight
            annotationView.canShowCallout = true
            let selectButton = UIButton()
            selectButton.frame = CGRect(x: 0, y: 0, width: 30, height: 50)
            selectButton.setImage(resizedImageLight, for: .normal)
            annotationView.rightCalloutAccessoryView = selectButton
            
            return annotationView
        }
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        if view.image == resizedImageLight {
            count = count + 1
            view.image = resizedImageDark
        } else {
            count = count - 1
            view.image = resizedImageLight
        }
        
        if count == 1 {
            addBottomView()
            bottomView.destinationLabel.text = "Select destination"
            bottomView.sourceLabel.text = (view.annotation?.title)!
        } else if count == 2 {
            bottomView.destinationLabel.text = (view.annotation?.title)!
            bottomView.searchButton.isHidden = false
        } else if count == 0 {
            
        }
    }
    
    func addBottomView() {
        
        view.addSubview(bottomView)
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        bottomView.backgroundColor = UIColor.white
        bottomView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bottomView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bottomView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -150).isActive = true
    }

}
