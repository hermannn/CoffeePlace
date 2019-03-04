//
//  Coordinator.swift
//  Guarana
//
//  Created by Hermann Dorio on 01/03/2019.
//  Copyright © 2019 Hermann Dorio. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    var childCoordinators: [Coordinator] { get set }
    func start()
}
