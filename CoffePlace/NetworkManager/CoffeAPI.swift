//
//  CoffeAPi.swift
//  Guarana
//
//  Created by Hermann Dorio on 19/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation

enum CoffeAPI {
    case coffeePlace(LocationData)
    case coffeeDetail(String)
    case photo(String, Int, Int)
}

extension CoffeAPI: EndpointType {
    
    var radius: String {
        return "1500" //in meter
    }
    
    var path: String {
        switch self {
        case .coffeePlace(_):
            return "nearbysearch/json"
        case .coffeeDetail(_):
            return "details/json"
        case .photo(_):
            return "photo"
        }
    }
    
    var httpMethod: HTTPMethod {
        return .get
    }
    
    var httpTask: HTTPTask {
        switch self {
        case .coffeePlace(let location):
            return .requestParameters(bodyParam: nil, urlParam: ["location": "\(location.lat), \(location.long)",
                "radius": radius,
                "type": "cafe",
                "key": "\(NetWorkManager.sharedInstance.apiKey)"])
        case .coffeeDetail(let placeId):
            return .requestParameters(bodyParam: nil, urlParam: [
                "placeid": placeId,
                "fields": "formatted_phone_number,website,formatted_address",
                "key": "\(NetWorkManager.sharedInstance.apiKey)"])
        case .photo(let ref, let maxHeigth, let maxWidth):
            return .requestParameters(bodyParam: nil, urlParam: ["photoreference": "\(ref)",
                "maxheigth": maxHeigth,
                "maxwidth": maxWidth,
                "key": "\(NetWorkManager.sharedInstance.apiKey)"])
        }
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var baseUrl: URL {
        guard let url =  URL(string: "https://maps.googleapis.com/maps/api/place") else {
            fatalError("couldn't create base URL CoffeAPi")
        }
        return url
    }
    
    func addPathToURL() -> URL {
        var fullURL = baseUrl
        fullURL.appendPathComponent(path)
        return fullURL
    }
}
