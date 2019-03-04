//
//  DetailCoordinator.swift
//  Guarana
//
//  Created by Hermann Dorio on 01/03/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import UIKit

class DetailCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var annotation: AnnotationCoffee
    
    init(navigationController: UINavigationController, annotation: AnnotationCoffee) {
        self.navigationController = navigationController
        self.annotation = annotation
    }
    
    func start() {
        let vc = DetailViewController()
        vc.coordinator = self
        vc.viewModel = DetailViewModel(data: annotation.info, annotation: annotation)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func displayWebView(urlString: String) {
        let child = WebViewCoordinator(navigationController: navigationController, urlString: urlString)
        childCoordinators.append(child)
        child.start()
    }
    
}
