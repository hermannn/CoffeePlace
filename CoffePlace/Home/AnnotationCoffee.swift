//
//  AnnotationCoffee.swift
//  Guarana
//
//  Created by Hermann Dorio on 22/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import MapKit

class AnnotationCoffee: NSObject, MKAnnotation {
    var info: CoffeePlace
    let coordinate: CLLocationCoordinate2D
    
    init(data: CoffeePlace) {
        self.info = data
        guard let latitude = data.locationCoffee?.latitude, let longitude = data.locationCoffee?.longitude else {
            fatalError("no coordinatefor coffee Annotation")
        }
        self.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String?{
        return nil
    }
    
    var subtitle: String?{
        return nil
    }
}
