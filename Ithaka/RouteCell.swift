//
//  RouteCell.swift
//  Ithaka
//
//  Created by Samarth Paboowal on 04/05/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit

class RouteCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    let transportLabel = UILabel()
    let sourceLabel = UILabel()
    let destinationLabel = UILabel()
    let centreLabel = UILabel()
    let timeLabel = UILabel()
    let durationLabel = UILabel()
    let costLabel = UILabel()
    
    func setupViews() {
        
        
        transportLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(transportLabel)
        transportLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        transportLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        transportLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        transportLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        transportLabel.textAlignment = .center
        transportLabel.textColor = UIColor(red: 240/255, green: 95/255, blue: 113/255, alpha: 1)
        transportLabel.text = "Samarth"
        
        
        self.addSubview(sourceLabel)
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.text = "Samarth"
        sourceLabel.font = UIFont.systemFont(ofSize: 18)
        sourceLabel.textAlignment = .center
        sourceLabel.textColor = UIColor.black
        sourceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        sourceLabel.topAnchor.constraint(equalTo: transportLabel.bottomAnchor, constant: 10).isActive = true
        sourceLabel.widthAnchor.constraint(equalToConstant: (self.bounds.width - 80)/2).isActive = true
        sourceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        self.addSubview(destinationLabel)
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationLabel.text = "Samarth"
        destinationLabel.font = UIFont.systemFont(ofSize: 18)
        destinationLabel.textAlignment = .center
        destinationLabel.textColor = UIColor.black
        destinationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        destinationLabel.widthAnchor.constraint(equalToConstant: (self.bounds.width - 80)/2).isActive = true
        destinationLabel.topAnchor.constraint(equalTo: transportLabel.bottomAnchor, constant: 10).isActive = true
        destinationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        self.addSubview(centreLabel)
        centreLabel.translatesAutoresizingMaskIntoConstraints = false
        centreLabel.text = ">"
        centreLabel.textAlignment = .center
        centreLabel.textColor = UIColor.red
        centreLabel.leftAnchor.constraint(equalTo: sourceLabel.rightAnchor, constant: 10).isActive = true
        centreLabel.topAnchor.constraint(equalTo: transportLabel.bottomAnchor, constant: 10).isActive = true
        centreLabel.rightAnchor.constraint(equalTo: destinationLabel.leftAnchor, constant: -10).isActive = true
        centreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(timeLabel)
        timeLabel.text = "Samarth"
        timeLabel.textAlignment = .center
        timeLabel.textColor = UIColor.blue
        timeLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        timeLabel.topAnchor.constraint(equalTo: centreLabel.bottomAnchor, constant: 10).isActive = true
        timeLabel.widthAnchor.constraint(equalToConstant: (self.bounds.width - 60)/3).isActive = true
        
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(durationLabel)
        durationLabel.text = "Samarth"
        durationLabel.textAlignment = .center
        durationLabel.textColor = UIColor.orange
        durationLabel.leftAnchor.constraint(equalTo: timeLabel.rightAnchor, constant: 10).isActive = true
        durationLabel.topAnchor.constraint(equalTo: centreLabel.bottomAnchor, constant: 10).isActive = true
        durationLabel.widthAnchor.constraint(equalToConstant: (self.bounds.width - 60)/3).isActive = true

        
        
        costLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(costLabel)
        costLabel.text = "Samarth"
        costLabel.textAlignment = .center
        costLabel.textColor = UIColor.green
        costLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        costLabel.topAnchor.constraint(equalTo: centreLabel.bottomAnchor, constant: 10).isActive = true
        costLabel.widthAnchor.constraint(equalToConstant: (self.bounds.width - 60)/3).isActive = true

    }

}
