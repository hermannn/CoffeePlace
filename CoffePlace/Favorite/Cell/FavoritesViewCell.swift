//
//  FavoritesViewCell.swift
//  Guarana
//
//  Created by Hermann Dorio on 22/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import UIKit

class FavoritesViewCell: UITableViewCell {

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    func setup(item: CoffeeDataPlace) {
        self.selectionStyle = .none
        nameLabel.text = item.name
        addressLabel.text = item.address
        let distanceString = String().displayDistanceForView(distanceKm: item.distanceInKMeter)
        distanceLabel.text = distanceString
    }
}
