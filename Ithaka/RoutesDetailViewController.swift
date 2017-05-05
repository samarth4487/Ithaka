//
//  RoutesDetailViewController.swift
//  Ithaka
//
//  Created by Samarth Paboowal on 04/05/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit

class RoutesDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var routes: [Route] = []
    var travels: [Travel]?
    var sortedRoutesCost: [Route] = []
    var sortedRoutesTime: [Route] = []
    
    @IBOutlet weak var sortingLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleSort))
        sortingLabel.addGestureRecognizer(tapGesture)
        sortingLabel.isUserInteractionEnabled = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 100
        
        for travel in travels! {
            let route = Route()
            var r = travel.routes
            route.cost = NSInteger((travel.totalCost)!)
            route.destination = r?[0]["to"] as? String
            route.duration = (travel.totalDuration)!
            route.source = r?[0]["from"] as? String
            route.time = r?[0]["time"] as? String
            route.transport = travel.type
            routes.append(route)
        }
        
        sortedRoutesCost = routes.sorted(by: { $0.cost! < $1.cost! })
        sortedRoutesTime = routes.sorted(by: { $0.duration! < $1.duration! })
    }
    
    func handleSort() {
        
        if sortingLabel.text == "Price" {
            sortingLabel.text = "Time"
        } else {
            sortingLabel.text = "Price"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (travels?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RouteCell
        
        tableView.rowHeight = 100
        cell.setupViews()
        
        cell.transportLabel.text = travels?[indexPath.row].type
        //cell.durationLabel.text = "\((travels?[indexPath.row].totalDuration)!) hours"
        //cell.costLabel.text = "\((travels?[indexPath.row].totalCost)!) THB"
        
        var routes = travels?[indexPath.row].routes
        cell.costLabel.text = "\((routes?[0]["cost"])!) THB"
        cell.durationLabel.text = "\((routes?[0]["duration"])!) hours"
        cell.timeLabel.text = routes?[0]["time"] as? String
        cell.sourceLabel.text = routes?[0]["from"] as? String
        cell.destinationLabel.text = routes?[0]["to"] as? String
        
        if (routes?.count)! > 1 {
            tableView.rowHeight = CGFloat(100 * (routes?.count)!)
            for x in 1 ..< (routes?.count)! {
                cell.additionalCellViews(factor: x)
                //cell.costLabelAdditional.text = "\((travels?[indexPath.row].totalCost)!) THB"
                
                var routes = travels?[indexPath.row].routes
                cell.costLabelAdditional.text = "\((routes?[x]["cost"])!) THB"
                cell.durationLabelAdditional.text = "\((routes?[x]["duration"])!) hours"
                cell.timeLabelAdditional.text = routes?[x]["time"] as? String
                cell.sourceLabelAdditional.text = routes?[x]["from"] as? String
                cell.destinationLabelAdditional.text = routes?[x]["to"] as? String
            }
        }
        
        return cell
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}

class Route {
    
    var transport: String?
    var source: String?
    var destination: String?
    var duration: Double?
    var cost: NSInteger?
    var time: String?
}
