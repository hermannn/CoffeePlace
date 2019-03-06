//
//  MockService.swift
//  CoffePlaceTests
//
//  Created by Hermann Dorio on 04/03/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
@testable import CoffePlace

class MockService: Service {
    
    var isGetCoffeePlaceWasCalled = false
    
    func getCoffeeInfo(placeId: String, completion: @escaping (Result, CoffeePlace?) -> ()) {
    }
    
    func getCoffeePlace(location: LocationData, completion: @escaping (Result, ListCoffeePlace?) -> ()) {
        isGetCoffeePlaceWasCalled = true
    }
}
