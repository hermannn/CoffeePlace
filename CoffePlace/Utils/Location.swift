//
//  Location.swift
//  Guarana
//
//  Created by Hermann Dorio on 18/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import CoreLocation

class Location {
    
    static let shared = Location()
    var manager: CLLocationManager = CLLocationManager()
    var currentLocation:CLLocation?
    
    private init() {
    }
    
    func configManagerLocation(delegate: CLLocationManagerDelegate){
        manager.delegate = delegate
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.distanceFilter = 10
    }
    
}

extension Location {
    
    func getLatitudeLongitudeFromCurrentLocation() -> (latitude: Double, longitude: Double)? {
        guard let latitude = currentLocation?.coordinate.latitude, let longitude = currentLocation?.coordinate.longitude else {
            return nil
        }
        return(latitude: latitude, longitude: longitude)
    }
}

