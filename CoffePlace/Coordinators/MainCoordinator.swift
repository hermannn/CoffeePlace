//
//  MainCoordinator.swift
//  Guarana
//
//  Created by Hermann Dorio on 01/03/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import UIKit

class MainCoordinator: NSObject, Coordinator{
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        navigationController.delegate = self
        displayHomeVC()
    }
    
    func displayHomeVC() {
        let child = HomeCoordinator(navigationController: navigationController)
        child.childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish(_ child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove(at: index)
                break
            }
        }
        
    }
}

extension MainCoordinator: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        guard let fromVC = navigationController.transitionCoordinator?.viewController(forKey: .from) else {
            return
        }
        // check the viewController where we from
        
        if navigationController.viewControllers.contains(fromVC) {
            return
        }
        //if the stack of navigationController contain fromVC means we just push on other view on top so fromVC is still here present on the stack
        
        
        // allow to make specific deletion for each view
        if let detailVC = fromVC as? DetailViewController {
            childDidFinish(detailVC.coordinator)
        }else if let homeVC = fromVC as? HomeViewController {
            childDidFinish(homeVC.coordinator)
        }else if let favVC = fromVC as? FavoritesViewController {
            childDidFinish(favVC.coordinator)
        }
    }
}
