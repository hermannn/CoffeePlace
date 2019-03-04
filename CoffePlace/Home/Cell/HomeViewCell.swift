//
//  HomeViewCell.swift
//  Guarana
//
//  Created by Hermann Dorio on 19/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import UIKit

class HomeViewCell: UITableViewCell {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var isopenLabel: UILabel!
    
    func setup(data: CoffeePlace){
        nameLabel.text = data.name
        isopenLabel.text = data.isOpen() ? "Open Now" : "Closed"
        isopenLabel.textColor = data.isOpen() ? .green : .red
        let distanceString = String().displayDistanceForView(distanceKm: data.getdistanceBetweenCurrentPositionInKM())
        distanceLabel.text = distanceString
    }
    
}
