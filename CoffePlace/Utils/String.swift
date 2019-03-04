//
//  String.swift
//  Guarana
//
//  Created by Hermann Dorio on 25/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation

extension String {
    
    func deleteHTMlTags() -> String {
        let newString = self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return newString
    }
    
    func keepOnlyNumericCharacters() -> String {
        return  self.components(separatedBy: CharacterSet.decimalDigits.inverted)
                .joined()
    }
    
    func displayDistanceForView(distanceKm: Double) -> String {
        if distanceKm < 1 {
            let distanceM = distanceKm * 1000
            return "\(distanceM) m"//in meter
        }
        return "\(distanceKm) km"
    }
}
