//
//  Double.swift
//  Guarana
//
//  Created by Hermann Dorio on 27/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation

extension Double {
    func meterInKmeter() -> Double{
        let meter = self.rounded()
        let kmeter = meter / 1000
        return kmeter
    }
}
