//
//  HomeViewController.swift
//  Guarana
//
//  Created by Hermann Dorio on 18/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RxCocoa
import CoreLocation
import RealmSwift
import Realm

class HomeViewController: UIViewController {

    weak var coordinator: HomeCoordinator?
    var viewModel = HomeViewModel(service: NetWorkManager.sharedInstance)
    let disposeBag = DisposeBag()
    @IBOutlet weak var mapView: MKMapView!{
        didSet {
            mapView.delegate = self
            mapView.isZoomEnabled = true
            mapView.showsUserLocation = true
        }
    }
    
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            let nib = UINib(nibName: "HomeViewCell", bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: "HomeViewCell")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupRx()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         Location.shared.configManagerLocation(delegate: self)
    }
    
    private func setupNavigationBar() {
        let heartImageFilled = UIImage(named: viewModel.heartImageFilledString)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = viewModel.textAttributes
        navigationItem.title = viewModel.navigationItemTitleString
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: heartImageFilled, style: .plain, target: self, action: #selector(heartIconWasClicked))
    }
    
    private func setupRx() {
        viewModel.stateCoffeeWs.asObservable()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] (state) in
            guard let ref = self else { return }
            switch state {
            case .done:
                ref.tableView.reloadData()
            case .fail(let errorString):
                print(errorString)
                break
            case .unactive, .loading:
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.listOfCoffeePlace.asObservable()
        .bind(to: tableView.rx.items) { tv, index, element in
            guard let cell = tv.dequeueReusableCell(withIdentifier: "HomeViewCell") as? HomeViewCell else {
                return UITableViewCell()
            }
            cell.setup(data: element)
            return cell
        }.disposed(by: disposeBag)
        
        tableView.rx.itemSelected.asObservable().subscribe(onNext: { [unowned self](indexPath) in
            guard let element = self.viewModel.getAnnotationFromTableViewAt(row: indexPath.row) else {
                return
            }
            self.coordinator?.displayDetail(annotation: element)
        }).disposed(by: disposeBag)
        
        viewModel.listAnnotationCoffeePlace.asObservable()
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (newAnnotations) in
            guard let ref = self else { return }
            ref.updateAnnotation(annotations: newAnnotations)
        }).disposed(by: disposeBag)
    }

    @objc func heartIconWasClicked(){
        coordinator?.displayFavorite()
    }
}

//MARK: func  using MapView
extension HomeViewController {
    func updateAnnotation(annotations: [AnnotationCoffee]) {
        mapView.addAnnotations(annotations)
    }
    
    func centerMapToCurrentLocation() {
        guard let currentLocation = Location.shared.currentLocation?.coordinate else  { return }
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 1500, longitudinalMeters: 1500)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension HomeViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let annotation = view.annotation as? AnnotationCoffee else { return }
        coordinator?.displayDetail(annotation: annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? AnnotationCoffee else { return nil }
        
        var viewAnnotation: MKAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: viewModel.identifierAnnotationCoffee) {
            viewAnnotation = dequeuedView
        }else {
            viewAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: viewModel.identifierAnnotationCoffee)
            viewAnnotation.image = UIImage(named: viewModel.listIconPlaceHolderString)
        }
        return viewAnnotation
    }
    
}

//Mark: Delegate CllocationManagerDelegate

extension HomeViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let newLocation = locations.last {
            if Location.shared.currentLocation?.coordinate != newLocation.coordinate {
                Location.shared.currentLocation = newLocation
                viewModel.getCurrentLocation()
                centerMapToCurrentLocation()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .denied:
            print("Denied")
        case .notDetermined:
            print("Not Determined")
        case .restricted:
            print("Restricted")
        default:
            Location.shared.manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Location.shared.manager.stopUpdatingLocation()
    }
}
