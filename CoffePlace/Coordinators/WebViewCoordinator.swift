//
//  WebViewCoordinator.swift
//  Guarana
//
//  Created by Hermann Dorio on 03/03/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import UIKit

class WebViewCoordinator: Coordinator {
    
    var navigationController: UINavigationController
    var childCoordinators: [Coordinator] = []
    var urlString:String
    
    init(navigationController: UINavigationController, urlString: String) {
        self.urlString = urlString
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = WebViewController()
        vc.coordinator = self
        vc.setupWebView(urlString: urlString)
        navigationController.pushViewController(vc, animated: true)
    }
}
