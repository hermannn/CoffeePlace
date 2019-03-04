//
//  FavoriteCoordinator.swift
//  Guarana
//
//  Created by Hermann Dorio on 01/03/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import UIKit

class FavoriteCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FavoritesViewController()
        vc.coordinator = self
        vc.viewModel = FavoriteViewModel()
        navigationController.pushViewController(vc, animated: true)
    }
}
