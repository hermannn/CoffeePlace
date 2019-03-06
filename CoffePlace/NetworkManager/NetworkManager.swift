//
//  Service.swift
//  Guarana
//
//  Created by Hermann Dorio on 18/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import RxSwift

//useful for test mockService with Dependency injection
protocol Service {
    func getCoffeePlace(location: LocationData, completion: @escaping(Result, ListCoffeePlace?) -> ())
    func getCoffeeInfo(placeId: String, completion: @escaping(Result, CoffeePlace?) -> ())
}

public typealias LocationData = (long: String, lat: String)

enum Result {
    case error(String)
    case success
}

class NetWorkManager {
    
    static let sharedInstance = NetWorkManager()
    let apiKey = "Enter API KEY"
    let router = Router<CoffeAPI>()
    
    
    private init() {
    }
    
}

extension NetWorkManager: Service {}
