//
//  HomeCoordinator.swift
//  Guarana
//
//  Created by Hermann Dorio on 01/03/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import UIKit

class HomeCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController){
        self.navigationController = navigationController
    }
    
    func start() {
        let homeViewController = HomeViewController()
        homeViewController.coordinator = self
        navigationController.navigationBar.barTintColor = .red
        navigationController.pushViewController(homeViewController, animated: true)
    }
    
    func displayFavorite() {
        let child = FavoriteCoordinator(navigationController: navigationController)
        childCoordinators.append(child)
        child.start()
    }
    
    func displayDetail(annotation: AnnotationCoffee) {
        let child = DetailCoordinator(navigationController: navigationController, annotation: annotation)
        childCoordinators.append(child)
        child.start()
    }
}
