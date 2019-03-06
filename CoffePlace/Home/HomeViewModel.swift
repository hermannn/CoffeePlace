//
//  HomeViewModel.swift
//  Guarana
//
//  Created by Hermann Dorio on 18/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import RxSwift

enum StateWs {
    case loading
    case done
    case fail(String)
    case unactive
}

class HomeViewModel {
    
    let service:Service
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    let navigationItemTitleString = "Coffee Place"
    let heartImageFilledString = "heart_filled"
    let listIconPlaceHolderString = "list_icon_placeholder"
    let identifierAnnotationCoffee = "annotationCoffee"
    var listOfCoffeePlace:Observable<[CoffeePlace]>!
    var listAnnotationCoffeePlace:Observable<[AnnotationCoffee]>!
    var stateCoffeeWs:Observable<StateWs>!
    
    private var stateCoffeeWs$ = Variable<StateWs>(.unactive)
    private var listOfCoffeePlace$ = Variable<[CoffeePlace]>([])
    private var locationOfUser = Variable<LocationData?>(nil)
    private var listAnnotationCoffeePlace$ = Variable<[AnnotationCoffee]>([])
    
    
    init(service: Service) {
        self.service = service
        listOfCoffeePlace = listOfCoffeePlace$.asObservable()
        listAnnotationCoffeePlace = listAnnotationCoffeePlace$.asObservable()
        stateCoffeeWs = stateCoffeeWs$.asObservable()
    }
    
    func getCurrentLocation() {
        guard let latitude = Location.shared.currentLocation?.coordinate.latitude, let longitude = Location.shared.currentLocation?.coordinate.longitude else {
            return
        }
        locationOfUser.value = LocationData(long: "\(longitude)", lat: "\(latitude)")
        fetchCoffeePlace()
    }
    
    func getAnnotationSelected(row: Int) -> AnnotationCoffee {
        return listAnnotationCoffeePlace$.value[row]
    }
    
    func getAnnotationFromTableViewAt(row: Int) -> AnnotationCoffee? {
        let element = getCoffeePlaceSelected(row: row)
        let annotation = listAnnotationCoffeePlace$.value.filter { (annotation) -> Bool in
            if let placeId = annotation.info.placeId, let elementId = element.placeId {
                return placeId == elementId
            }
            return false
        }
        return annotation.first
    }
    
    private func getCoffeePlaceSelected(row: Int) -> CoffeePlace {
        return listOfCoffeePlace$.value[row]
    }
    
    private func fetchCoffeePlace()  {
        stateCoffeeWs$.value = .loading
        guard let currentLocation = locationOfUser.value else {
            stateCoffeeWs$.value = StateWs.fail("error no location")
            return
        }
        service.getCoffeePlace(location: currentLocation) { (result, data) in
            switch result {
            case .error(let msg):
                self.stateCoffeeWs$.value = StateWs.fail(msg)
            case .success:
                guard let listCoffee = data else { return }
                self.updateAnnotationCoffee(data: listCoffee.place)
                self.listOfCoffeePlace$.value = listCoffee.place
                self.stateCoffeeWs$.value = StateWs.done
            }
        }
    }
    
    private func updateAnnotationCoffee(data: [CoffeePlace]) {
        listAnnotationCoffeePlace$.value.removeAll()
        listAnnotationCoffeePlace$.value =  data.map({ return AnnotationCoffee(data: $0)})
    }
}
