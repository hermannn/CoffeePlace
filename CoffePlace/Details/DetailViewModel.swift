//
//  DetailViewModel.swift
//  Guarana
//
//  Created by Hermann Dorio on 23/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import CoreLocation


class DetailViewModel {

    let disposeBag = DisposeBag()
    let preffixUrlPhoneString = "tel://"
    let rightBarBtnImgString = "phone"
    let listIconPlaceHolder = "list_icon_placeholder"
    let identifierAnnotationCoffee = "annotationCoffee"
    let latitudeMeterForCenterMap:Double = 1500 // in meter
    let longitudeMeterForCenterMap:Double = 1500 //in meter
    let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
    var navigationTitleString:Observable<String>!
    var addressTextString:Observable<String>!
    var coffeeWithFullInfo:Observable<CoffeePlace?>!
    var stateCoffeeWs:Observable<StateWs>!
    var statePhotoDownload:Observable<StateWs>!
    var imageData:Observable<Data?>
    var isFavorite:Observable<Bool>
    var isOpen:Observable<Bool>!
    
    private var coffeWithFullInfo$ = Variable<(CoffeePlace?)>(nil)
    private var navigationTitleString$ = Variable<String>("")
    private var addressTextString$ = Variable<String>("")
    private var annotationCoffeePlace:AnnotationCoffee
    private var info:CoffeePlace
    private var stateCoffeeWs$ = Variable<StateWs>(.unactive)
    private var statePhotoDownload$ = Variable<StateWs>(.unactive)
    private var imageData$ = Variable<Data?>(nil)
    private var isFavorite$ = Variable<Bool>(false)
    private var isOpen$ = Variable<Bool>(false)
    
    init(data:CoffeePlace, annotation: AnnotationCoffee) {
        self.info = data
        self.annotationCoffeePlace = annotation
        self.imageData = imageData$.asObservable()
        self.isFavorite = isFavorite$.asObservable()
        self.isOpen = isOpen$.asObservable()
        self.statePhotoDownload = statePhotoDownload$.asObservable()
        self.stateCoffeeWs = stateCoffeeWs$.asObservable()
        self.coffeeWithFullInfo = coffeWithFullInfo$.asObservable()
        self.navigationTitleString = navigationTitleString$.asObservable()
        self.addressTextString = addressTextString$.asObservable()
        self.fetchPhotoCoffeePlace()
        self.fetchInfoPlace()
        setupRx()
    }
    
    private func setupRx() {
        coffeeWithFullInfo.subscribe(onNext: { (data) in
            guard let coffee = data else { return }
            self.navigationTitleString$.value = coffee.name ?? ""
            self.addressTextString$.value = coffee.address ?? ""
        }).disposed(by: disposeBag)
    }
    
    private func fillWithFullInfo(data: CoffeePlace) {
        info.website = data.website
        info.phone = data.phone
        info.address = data.address
        coffeWithFullInfo$.value = info
        isOpen$.value = (coffeWithFullInfo$.value?.isopen ?? false)
        self.isFavorite$.value = self.isCoffeePlaceFavorite()
    }
    
    func getAnnotationCoffee() -> AnnotationCoffee {
        return annotationCoffeePlace
    }
    
    func getAnnotationCoffeeCoordinate() -> CLLocationCoordinate2D{
        return annotationCoffeePlace.coordinate
    }
    
    func getTextIsPlaceOpen() -> String {
        return isOpen$.value ? "Open Now" : "Close"
    }
    
    func getNumber() -> String? {
        guard let phone = coffeWithFullInfo$.value?.phone else {
            return nil
        }
        return phone.keepOnlyNumericCharacters()
    }
    
    func getStringURL() -> String? {
        return coffeWithFullInfo$.value?.website
    }
    
    func isCoffeePlaceFavorite() -> Bool {
        guard let id = info.placeId else { return false }
        do {
            let realm = try Realm()
            let elem = realm.objects(CoffeeDataPlace.self).filter("placeId=%@", id)
            if let _ = elem.first {
                return true
            }
            return false
        }catch {
            print("Error Realm in isCoffeePlaceFavorite method")
            return false
        }
    }
    
    func updateFavorite() {
        isFavorite$.value = !isFavorite$.value
        guard let data = coffeWithFullInfo$.value else { return }
        let dataForRealm = CoffeeDataPlace(data: data)
        do {
            let realm = try Realm()
            if isFavorite$.value {
                try realm.write {
                    realm.add(dataForRealm)
                }
            }else {
                guard let id = dataForRealm.placeId else { return }
                try! realm.write {
                    realm.delete(realm.objects(CoffeeDataPlace.self).filter("placeId=%@", id))
                }
            }
        }catch {
            print("Error Realm in updateFavorite method")
        }
    }
    
    func fetchPhotoCoffeePlace() {
        let width = Int(UIScreen.main.bounds.width)
        let height = Int(UIScreen.main.bounds.height)
        guard let photo = info.photos?.first else { return }
        statePhotoDownload$.value = .loading
        NetWorkManager.sharedInstance.getPhoto(ref: photo.ref, maxWidth: width, maxHeight: height) { (result, data) in
            switch result {
            case .error(let text):
                self.statePhotoDownload$.value = .fail(text)
            case .success:
                guard let imgData = data else { return }
                self.imageData$.value = imgData
                self.statePhotoDownload$.value = .done
            }
        }
    }
    
    func fetchInfoPlace() {
        stateCoffeeWs$.value = .loading
        guard let id = info.placeId else {
            stateCoffeeWs$.value = .fail("no place id ")
            return
        }
        NetWorkManager.sharedInstance.getCoffeeInfo(placeId: id) { (result, data) in
            switch result {
            case .error(let text):
                self.stateCoffeeWs$.value = .fail(text)
            case .success:
                guard let fullInfo = data else { return }
                self.fillWithFullInfo(data: fullInfo)
                self.stateCoffeeWs$.value = .done
            }
        }
    }
}
