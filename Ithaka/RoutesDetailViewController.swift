//
//  RoutesDetailViewController.swift
//  Ithaka
//
//  Created by Samarth Paboowal on 04/05/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit

class RoutesDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var routes: [[Dictionary<String, Any>]] = []
    var travels: [Travel]?
    var sortedRoutesCost: [[Dictionary<String, Any>]] = []
    var sortedRoutesTime: [[Dictionary<String, Any>]] = []
    
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
        
        costSort()
    }
    
    func costSort() {
        
        travels = travels?.sorted(by: { $0.totalCost! < $1.totalCost! })
        
        routes = []
        for travel in travels! {
            routes.append(travel.routes!)
        }
    }
    
    func timeSort() {
        
        travels = travels?.sorted(by: { $0.totalDuration! < $1.totalDuration! })
        
        routes = []
        for travel in travels! {
            routes.append(travel.routes!)
        }
    }
    
    func handleSort() {
        
        if sortingLabel.text == "Price" {
            timeSort()
            sortingLabel.text = "Time"
            tableView.reloadData()
        } else {
            costSort()
            sortingLabel.text = "Price"
            tableView.reloadData()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return routes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! RouteCell
        
        tableView.rowHeight = 100
        cell.setupViews()
        
        cell.transportLabel.text = routes[indexPath.row][0]["mode"] as? String
        cell.costLabel.text = "\((routes[indexPath.row][0]["cost"])!) THB"
        cell.durationLabel.text = "\((routes[indexPath.row][0]["duration"])!) hours"
        cell.timeLabel.text = routes[indexPath.row][0]["time"] as? String
        cell.sourceLabel.text = routes[indexPath.row][0]["from"] as? String
        cell.destinationLabel.text = routes[indexPath.row][0]["to"] as? String
        
        if (routes[indexPath.row].count) > 1 {
            tableView.rowHeight = CGFloat(100 * (routes[indexPath.row].count))
            for x in 1 ..< (routes[indexPath.row].count) {
                cell.additionalCellViews(factor: x)
                cell.costLabelAdditional.text = "\((routes[indexPath.row][x]["cost"])!) THB"
                cell.durationLabelAdditional.text = "\((routes[indexPath.row][x]["duration"])!) hours"
                cell.timeLabelAdditional.text = routes[indexPath.row][x]["time"] as? String
                cell.sourceLabelAdditional.text = routes[indexPath.row][x]["from"] as? String
                cell.destinationLabelAdditional.text = routes[indexPath.row][x]["to"] as? String
            }
        }
        
        return cell
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        dismiss(animated: true, completion: nil)
    }
}
