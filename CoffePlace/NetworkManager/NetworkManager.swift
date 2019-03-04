//
//  Service.swift
//  Guarana
//
//  Created by Hermann Dorio on 18/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import RxSwift

public typealias LocationData = (long: String, lat: String)

enum Result {
    case error(String)
    case success
}

class NetWorkManager {
    
    static let sharedInstance = NetWorkManager()
    let apiKey = "ENTER YOUR API KEY"
    let router = Router<CoffeAPI>()
    
    
    private init() {
    }
    
}
