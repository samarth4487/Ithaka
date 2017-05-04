//
//  MapsViewControllerExtension.swift
//  Ithaka
//
//  Created by Samarth Paboowal on 04/05/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit

extension MapViewController {
    
    func handleSearch() {
        
        let URL = "http://dev.ithaka.travel/transport/from/\(sourceName!)/to/\(destinationName!)"
        let url = NSURL(string: URL)
        let request = URLRequest(url: url! as URL)
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
            
            DispatchQueue.main.async {
                
            }
            
        }.resume()
    }
}
