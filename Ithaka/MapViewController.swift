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

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    var resizedImageLight: UIImage?
    var resizedImageDark: UIImage?
    let bottomView = BottomView()
    var count = 0
    var sourceName: String?
    var destinationName: String?
    var travels = [Travel]()
    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        scrollView.isHidden = true
//        
//        resizeImages()
//        requestLocationAccess()
//        addAnnotations()
//        
//        let latitude:CLLocationDegrees = 10.4930
//        let longitude:CLLocationDegrees = 99.1800
//        let latDelta:CLLocationDegrees = 4
//        let lonDelta:CLLocationDegrees = 4
//        let span = MKCoordinateSpanMake(latDelta, lonDelta)
//        let location = CLLocationCoordinate2DMake(latitude, longitude)
//        let region = MKCoordinateRegionMake(location, span)
//        
//        mapView.setRegion(region, animated: false)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        count = 0
        travels = []
        scrollView.isHidden = true
        
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        let anno = mapView.annotations
        mapView.removeAnnotations(anno)
        //bottomView.removeFromSuperview()
        //additionalButton.removeFromSuperview()
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
            print(1)
            count = count + 1
            view.image = resizedImageDark
        } else {
            count = count - 1
            view.image = resizedImageLight
        }
        
        if count == 1 {
            print(2)
            addBottomView()
            sourceName = (view.annotation?.title)!
            print(4)
            bottomView.sourceLabel.text = sourceName
            bottomView.destinationLabel.text = "Select destination"
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
        print(3)
    }
    
    func handleSearch() {
        
        let newSourceName = sourceName?.replacingOccurrences(of: " ", with: "%20")
        let newDestinationName = destinationName?.replacingOccurrences(of: " ", with: "%20")
        let URL = "http://dev.ithaka.travel/transport/from/\(newSourceName!)/to/\(newDestinationName!)"
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
                        travel.totalDuration = obj["totalDuration"] as? Double
                        travel.totalCost = obj["totalCost"] as? Double
                        travel.routes = obj["routes"] as? [[String : Any]]
                        self.travels.append(travel)
                    }
                    print(self.travels.count)
                    
                    DispatchQueue.main.async {
                        self.buildCards()
                    }
                }
            }
            
            }.resume()
    }
    
    func buildCards() {
        
        bottomView.removeFromSuperview()
        scrollView.isHidden = false
        
        let width: CGFloat = 240
        let height: CGFloat = 128
        let screenWidth = UIScreen.main.bounds.width
        let leftEdge = (screenWidth - width) / 2
        let factor = travels.count
        
        //if travels.count > 2 {
            //factor = 2
        //} else {
            //factor = travels.count
        //}
        for x in 0 ..< factor{
            
            let routes = travels[x].routes
            let mainView = UIView()
            mainView.backgroundColor = UIColor.white
            mainView.layer.masksToBounds = true
            mainView.layer.cornerRadius = 10
            scrollView.addSubview(mainView)
            
            mainView.frame = CGRect(x: leftEdge + (screenWidth * CGFloat(x)), y: 11, width: width, height: height)
            
            let sourceLabel = UILabel()
            mainView.addSubview(sourceLabel)
            sourceLabel.translatesAutoresizingMaskIntoConstraints = false
            sourceLabel.text = routes?[0]["from"] as? String
            sourceLabel.font = UIFont.systemFont(ofSize: 12)
            sourceLabel.textAlignment = .center
            sourceLabel.textColor = UIColor.black
            sourceLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
            sourceLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
            sourceLabel.widthAnchor.constraint(equalToConstant: (mainView.bounds.width - 50)/2).isActive = true
            sourceLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            let destinationLabel = UILabel()
            mainView.addSubview(destinationLabel)
            destinationLabel.translatesAutoresizingMaskIntoConstraints = false
            destinationLabel.text = routes?[0]["to"] as? String
            destinationLabel.font = UIFont.systemFont(ofSize: 12)
            destinationLabel.textAlignment = .center
            destinationLabel.textColor = UIColor.black
            destinationLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -10).isActive = true
            destinationLabel.widthAnchor.constraint(equalToConstant: (mainView.bounds.width - 50)/2).isActive = true
            destinationLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
            destinationLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            let centreLabel = UILabel()
            mainView.addSubview(centreLabel)
            centreLabel.translatesAutoresizingMaskIntoConstraints = false
            centreLabel.text = ">"
            centreLabel.textAlignment = .center
            centreLabel.textColor = UIColor.red
            centreLabel.leftAnchor.constraint(equalTo: sourceLabel.rightAnchor, constant: 10).isActive = true
            centreLabel.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
            centreLabel.rightAnchor.constraint(equalTo: destinationLabel.leftAnchor, constant: -10).isActive = true
            centreLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            let middleLine = UIView()
            middleLine.translatesAutoresizingMaskIntoConstraints = false
            mainView.addSubview(middleLine)
            middleLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
            middleLine.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
            middleLine.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -10).isActive = true
            middleLine.backgroundColor = UIColor.gray
            middleLine.topAnchor.constraint(equalTo: centreLabel.bottomAnchor, constant: 5).isActive = true
            
            let transportLabel = UILabel()
            mainView.addSubview(transportLabel)
            transportLabel.translatesAutoresizingMaskIntoConstraints = false
            transportLabel.textAlignment = .center
            transportLabel.font = UIFont.systemFont(ofSize: 22)
            transportLabel.leftAnchor.constraint(equalTo: mainView.leftAnchor, constant: 10).isActive = true
            transportLabel.text = travels[x].type
            transportLabel.rightAnchor.constraint(equalTo: mainView.rightAnchor, constant: -10).isActive = true
            transportLabel.textColor = UIColor.lightGray
            transportLabel.topAnchor.constraint(equalTo: middleLine.bottomAnchor, constant: 5).isActive = true
            
            let timeLabel = UILabel()
            mainView.addSubview(timeLabel)
            timeLabel.translatesAutoresizingMaskIntoConstraints = false
            timeLabel.textAlignment = .center
            timeLabel.font = UIFont.systemFont(ofSize: 16)
            timeLabel.text = "\(travels[0].totalDuration!) hours"
            timeLabel.textColor = UIColor.orange
            timeLabel.topAnchor.constraint(equalTo: transportLabel.bottomAnchor, constant: 10).isActive = true
            timeLabel.rightAnchor.constraint(equalTo: mainView.centerXAnchor, constant: -10).isActive = true
            timeLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
            
            let costLabel = UILabel()
            mainView.addSubview(costLabel)
            costLabel.translatesAutoresizingMaskIntoConstraints = false
            costLabel.textAlignment = .center
            costLabel.font = UIFont.systemFont(ofSize: 16)
            costLabel.text = "\(travels[0].totalCost!) THB"
            costLabel.textColor = UIColor.green
            costLabel.topAnchor.constraint(equalTo: transportLabel.bottomAnchor, constant: 10).isActive = true
            costLabel.leftAnchor.constraint(equalTo: mainView.centerXAnchor, constant: 10).isActive = true
            costLabel.widthAnchor.constraint(equalToConstant: 90).isActive = true
            
            let additionalButton = UIButton(type: .system)
            scrollView.addSubview(additionalButton)
            additionalButton.translatesAutoresizingMaskIntoConstraints = false
            additionalButton.layer.masksToBounds = true
            additionalButton.layer.cornerRadius = 25
            additionalButton.isHidden = true
            additionalButton.setBackgroundImage(UIImage(named: "plus-512"), for: .normal)
            additionalButton.leftAnchor.constraint(equalTo: mainView.rightAnchor, constant: 10).isActive = true
            additionalButton.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
            additionalButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            additionalButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            additionalButton.addTarget(self, action: #selector(handleDetails), for: UIControlEvents.touchUpInside)
            
            if x == factor - 1 {
                additionalButton.isHidden = false
            }
        }
        
        scrollView.contentSize = CGSize(width: (UIScreen.main.bounds.width * CGFloat(factor)), height: scrollView.frame.size.height)
    }
    
    func handleDetails() {
        
        performSegue(withIdentifier: "detail", sender: travels)
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "detail" {
            if let nextScene = segue.destination as? RoutesDetailViewController {
                nextScene.travels = sender as? [Travel]
                //print(sender)
            }
        }
        
    }

}
