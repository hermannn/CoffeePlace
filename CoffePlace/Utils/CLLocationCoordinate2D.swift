//
//  CLLocationCoordinate2D.swift
//  Guarana
//
//  Created by Hermann Dorio on 18/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import CoreLocation
import Foundation

extension CLLocationCoordinate2D: Equatable {
    
    public static func ==(lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return
            lhs.latitude == rhs.latitude &&
                lhs.longitude == rhs.longitude
    }

    
}
