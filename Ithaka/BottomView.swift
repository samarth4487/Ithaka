//
//  BottomView.swift
//  Ithaka
//
//  Created by Samarth Paboowal on 04/05/17.
//  Copyright © 2017 Junkie Labs. All rights reserved.
//

import UIKit

class BottomView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupViews()
    }
    
    var sourceLabel = UILabel()
    var destinationLabel = UILabel()
    var searchButton = UIButton(type: .system)
    
    let width = UIScreen.main.bounds.width - 80
    
    func setupViews() {
        
        let titleLabel = UILabel()
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Search transport info between:"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.red
        titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(sourceLabel)
        sourceLabel.translatesAutoresizingMaskIntoConstraints = false
        sourceLabel.text = "Select source"
        sourceLabel.textAlignment = .center
        sourceLabel.textColor = UIColor.black
        sourceLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        sourceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        sourceLabel.widthAnchor.constraint(equalToConstant: width/2).isActive = true
        sourceLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
        addSubview(destinationLabel)
        destinationLabel.translatesAutoresizingMaskIntoConstraints = false
        destinationLabel.text = "Select destination"
        destinationLabel.textAlignment = .center
        destinationLabel.textColor = UIColor.black
        destinationLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20).isActive = true
        destinationLabel.widthAnchor.constraint(equalToConstant: width/2).isActive = true
        destinationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        destinationLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        let centreLabel = UILabel()
        addSubview(centreLabel)
        centreLabel.translatesAutoresizingMaskIntoConstraints = false
        centreLabel.text = ">"
        centreLabel.textAlignment = .center
        centreLabel.textColor = UIColor.red
        centreLabel.leftAnchor.constraint(equalTo: sourceLabel.rightAnchor, constant: 10).isActive = true
        centreLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        centreLabel.rightAnchor.constraint(equalTo: destinationLabel.leftAnchor, constant: -10).isActive = true
        centreLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        addSubview(searchButton)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.layer.masksToBounds = true
        searchButton.layer.cornerRadius = 5
        searchButton.setTitle("Search", for: .normal)
        searchButton.isHidden = true
        searchButton.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        searchButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
