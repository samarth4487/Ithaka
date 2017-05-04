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
    var sourceName: String?
    var destinationName: String?
    var travels = [Travel]()
    
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
            sourceName = (view.annotation?.title)!
            bottomView.sourceLabel.text = sourceName
        } else if count == 2 {
            destinationName = (view.annotation?.title)!
            bottomView.destinationLabel.text = destinationName
            bottomView.searchButton.isHidden = false
            bottomView.searchButton.addTarget(self, action: #selector(handleSearch), for: .touchUpInside)
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
    
    func handleSearch() {
        
        let URL = "http://dev.ithaka.travel/transport/from/\(sourceName!)/to/\(destinationName!)"
        let url = NSURL(string: URL)
        let request = URLRequest(url: url! as URL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            let fetchedData = try? JSONSerialization.jsonObject(with: data!, options: []) as? [Any]
            
            if let j = fetchedData {
                if let objectArray = j {
                    for object in objectArray {
                        let obj = object as! Dictionary<String, Any>
                        print(object)
                        let travel = Travel()
                        travel.type = obj["type"] as? String
                        travel.totalDuration = obj["totalDuration"] as? String
                        travel.totalCost = obj["totalCost"] as? String
                        travel.routes = obj["routes"] as? [[String : Any]]
                        self.travels.append(travel)
                    }
                    print(self.travels.count)
                }
            }
            
            }.resume()
    }
    
    func buildCards() {
        
        
    }

}
