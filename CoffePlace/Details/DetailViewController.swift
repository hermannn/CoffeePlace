//
//  DetailViewController.swift
//  Guarana
//
//  Created by Hermann Dorio on 22/02/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import UIKit
import MapKit
import RxSwift
import RealmSwift

class DetailViewController: UIViewController {

    weak var coordinator: DetailCoordinator?
    var viewModel:DetailViewModel!
    let disposeBag = DisposeBag()
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var mapView: MKMapView!{
        didSet {
            mapView.delegate = self
        }
    }
    @IBOutlet weak var isOpenLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var favoriteBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        setupRx()
    }
    
    func setupNavigationBar(){
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes = viewModel.textAttributes
        let rightBarbtnImage = UIImage(named: viewModel.rightBarBtnImgString)
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: rightBarbtnImage, style: .plain, target: self, action: #selector(phoneBarBtnWasPressed))
        favoriteBtn.imageView?.image?.withRenderingMode(.alwaysTemplate)
    }
    
    @objc func phoneBarBtnWasPressed() {
        guard let phoneNumberString = viewModel.getNumber() else {
            return
        }
        guard let number = URL(string: viewModel.preffixUrlPhoneString + phoneNumberString) else {
            return
        }
        UIApplication.shared.open(number, options: [:], completionHandler: nil)
    }
    
    private func setupRx() {
        viewModel.stateCoffeeWs.asObservable()
        .observeOn(MainScheduler.instance)
        .subscribe(onNext: { [weak self] (state) in
            guard let ref = self else { return }
            switch state {
            case .fail(let text):
                print("handle error \(text)")
            case .done:
                ref.updateMapView()
            default:
                break
            }
        }).disposed(by: disposeBag)
        
        viewModel.statePhotoDownload.asObservable()
            .subscribe(onNext: { (state) in
                switch state {
                case .fail(let text):
                    print("handle error image \(text)")
                default:
                    break
                }
            }).disposed(by: disposeBag)
        
        viewModel.imageData
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (data) in
            guard let imgData = data, let ref = self else { return }
            ref.photoImageView.image = UIImage(data: imgData)
        }).disposed(by: disposeBag)
        
        viewModel.isFavorite
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (newValue) in
                guard let ref = self else { return }
                if newValue {
                    ref.favoriteBtn.imageView?.tintColor = .red
                }else {
                    ref.favoriteBtn.imageView?.tintColor = .gray
                }
            }).disposed(by: disposeBag)
        
        viewModel.navigationTitleString.bind(to: navigationItem.rx.title).disposed(by: disposeBag)
        viewModel.addressTextString.bind(to: addressLabel.rx.text).disposed(by: disposeBag)
        viewModel.isOpen
            .observeOn(MainScheduler.instance)
            .subscribe(onNext:  { [weak self] (isOpen) in
                guard let ref = self else { return }
            ref.isOpenLabel.textColor = isOpen ? .green : .red
            ref.isOpenLabel.text = ref.viewModel.getTextIsPlaceOpen()
        }).disposed(by: disposeBag)
    }
    
    private func updateMapView() {
        centerMapToItemLocation()
        updateAnnotation()
    }
    
    @IBAction func favoritesBtnPressed(_ sender: UIButton) {
        viewModel.updateFavorite()
    }
    
    @IBAction func openWebsiteBtnPressed(_ sender: UIButton) {
        guard let urlString = viewModel.getStringURL() else { return }
        coordinator?.displayWebView(urlString: urlString)
    }
}

extension DetailViewController {
    
    func updateAnnotation() {
        mapView.addAnnotation(viewModel.getAnnotationCoffee())
    }
    
    func centerMapToItemLocation() {
        let currentLocation = viewModel.getAnnotationCoffeeCoordinate()
        let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: CLLocationDistance(viewModel.latitudeMeterForCenterMap), longitudinalMeters: viewModel.longitudeMeterForCenterMap)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}

extension DetailViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let annotation = annotation as? AnnotationCoffee else { return nil }
        
        var viewAnnotation: MKAnnotationView
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: viewModel.identifierAnnotationCoffee) {
            viewAnnotation = dequeuedView
        }else {
            viewAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: viewModel.identifierAnnotationCoffee)
            viewAnnotation.image = UIImage(named: viewModel.listIconPlaceHolder)
        }
        return viewAnnotation
    }
}
