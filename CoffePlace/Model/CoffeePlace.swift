//
//  CoffeePlace.swift
//  Guarana
//
//  Created by Hermann Dorio on 18/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

struct CoffeeCoordinate: Decodable {
    var latitude: Double
    var longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lng"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        latitude = try values.decode(Double.self, forKey: .latitude)
        longitude = try values.decode(Double.self, forKey: .longitude)
    }
}

struct Photo: Decodable {
    var ref:String
    
    enum CodingKeys: String, CodingKey {
        case reference = "photo_reference"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        ref = try values.decode(String.self, forKey: .reference)
    }
}

class CoffeeDataPlace: Object {
    
    @objc dynamic var placeId: String?
    @objc dynamic var address: String?
    @objc dynamic var name: String?
    @objc dynamic var isopen: Bool = false
    @objc dynamic var distanceInKMeter: Double = 0
    
    convenience init(data: CoffeePlace) {
        self.init()
        self.placeId = data.placeId
        self.address = data.address
        self.name = data.name
        self.isopen = data.isopen ?? false
        self.distanceInKMeter = data.getdistanceBetweenCurrentPositionInKM()
    }
}

struct CoffeePlace: Decodable{
    var placeId: String?
    var name:String?
    var locationCoffee: CoffeeCoordinate?
    var isopen: Bool?
    var address: String?
    var photos: [Photo]?
    var phone: String?
    var website: String?
    
    enum CodingKeys: String, CodingKey {
        case result
        case name
        case geometry
        case location
        case openingHours = "opening_hours"
        case openNow = "open_now"
        case address = "formatted_address"
        case photos
        case placeId = "place_id"
        case website
        case phone = "formatted_phone_number"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        address = try values.decodeIfPresent(String.self, forKey: .address)
        if values.contains(.openingHours) {
            let openingHours = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .openingHours)
            isopen = try openingHours.decodeIfPresent(Bool.self, forKey: .openNow)
        }
        if values.contains(.geometry) {
            let geometry = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .geometry)
            locationCoffee = try geometry.decodeIfPresent(CoffeeCoordinate.self, forKey: .location)
        }
        photos = try values.decodeIfPresent([Photo].self, forKey: .photos)
        if values.contains(.placeId) {
            placeId = try values.decode(String.self, forKey: .placeId)
        }
        if values.contains(.result) {
            let result = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .result)
            phone = try result.decodeIfPresent(String.self, forKey: .phone)
            website = try result.decodeIfPresent(String.self, forKey: .website)
            address = try result.decodeIfPresent(String.self, forKey: .address)
        }
    }
}

extension CoffeePlace {
    
    func isOpen() -> Bool {
        return self.isopen ?? false
    }
    
    func getdistanceBetweenCurrentPositionInKM() -> CLLocationDistance {
        guard let lat = self.locationCoffee?.latitude , let long = self.locationCoffee?.longitude else {
            return 0
        }
        let coffeeLocation = CLLocation(latitude: lat, longitude: long)
        if let meter = Location.shared.currentLocation?.distance(from: coffeeLocation)
        {
            return meter.meterInKmeter()
        }
        return 0
    }
}

struct ListCoffeePlace: Decodable {
    var place: [CoffeePlace]
    
    enum CodingKeys: String, CodingKey {
        case place = "results"
    }
    
    init(from decoder: Decoder) throws {
        let result = try decoder.container(keyedBy: CodingKeys.self)
        place = try result.decode([CoffeePlace].self, forKey: .place)
    }
}
