//
//  CoffeePlaceService.swift
//  Guarana
//
//  Created by Hermann Dorio on 18/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation

extension NetWorkManager {
    
    func getCoffeePlace(location: LocationData, completion: @escaping(Result, ListCoffeePlace?) -> ()){
        router.request(.coffeePlace(location)) { (result, data) in
            switch result {
            case .error(let text):
                completion(Result.error(text), nil)
            case .success:
                guard let dataReceived = data else {
                    completion(Result.error("no data"), nil)
                    return
                }
                do {
                    let listcoffeePlace = try JSONDecoder().decode(ListCoffeePlace.self, from: dataReceived)
                    completion(Result.success, listcoffeePlace)
                }catch {
                    completion(Result.error("couldn't deocde"), nil)
                }
            }
        }
    }
    
    func getCoffeeInfo(placeId: String, completion: @escaping(Result, CoffeePlace?) -> ()){
        router.request(.coffeeDetail(placeId)) { (result, data) in
            switch result {
            case .error(let text):
                completion(Result.error(text), nil)
            case .success:
                guard let dataReceived = data else {
                    completion(Result.error("no data"), nil)
                    return
                }
                do {
                    let coffeeInfo = try JSONDecoder().decode(CoffeePlace.self, from: dataReceived)
                    completion(Result.success, coffeeInfo)
                }catch {
                    completion(Result.error("couldn't deocde"), nil)
                }
            }
        }
    }
    
    func getPhoto(ref: String, maxWidth: Int, maxHeight: Int, completion: @escaping(Result, Data?) -> ()){
        router.request(.photo(ref, maxWidth, maxHeight)) { (result, data) in
            switch result {
                case .error(let text):
                    completion(Result.error(text), nil)
                case .success:
                    guard let dataReceived = data else {
                        completion(Result.error("no data"), nil)
                        return
                    }
                completion(Result.success, dataReceived)
            }
        }
    }
}
