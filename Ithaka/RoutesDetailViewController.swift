//
//  RoutesDetailViewController.swift
//  Ithaka
//
//  Created by Samarth Paboowal on 04/05/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit

class RoutesDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var travels: [Travel]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (travels?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RouteCell
        
        cell.setupViews()
        
        cell.transportLabel.text = travels?[indexPath.row].type
        cell.durationLabel.text = "\((travels?[indexPath.row].totalDuration)!) hours"
        cell.costLabel.text = "\((travels?[indexPath.row].totalCost)!) THB"
        
        let routes = travels?[indexPath.row].routes
        cell.timeLabel.text = routes?[0]["time"] as? String
        cell.sourceLabel.text = routes?[0]["from"] as? String
        cell.destinationLabel.text = routes?[0]["to"] as? String
        
        
        return cell
    }
}
