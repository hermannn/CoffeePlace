//
//  FavoriteViewModel.swift
//  Guarana
//
//  Created by Hermann Dorio on 26/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxRealm

class FavoriteViewModel {
    let navigationTitle = "Favorites"
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    func fecthDataFrom() -> Observable<Results<CoffeeDataPlace>> {
        do {
            let realm = try Realm()
            let elem = realm.objects(CoffeeDataPlace.self)
            if elem.count == 0 {
                return Observable.empty()
            }
            return Observable.collection(from: elem)
        }catch let error {
            print("Error Realm in fetchDataFrom method")
            return Observable.error(error)
        }
    }
}
