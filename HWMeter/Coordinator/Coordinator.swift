//
//  Coordinator.swift
//  HWMeter
//
//  Created by Duy Nguyen on 9/18/20.
//  Copyright © 2020 Duy Nguyen. All rights reserved.
//

import UIKit


protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    
    func start()
}
