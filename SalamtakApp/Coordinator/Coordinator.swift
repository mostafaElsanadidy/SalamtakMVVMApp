//
//  Coordinator.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 21.11.22.
//  Copyright © 2022 mostafa elsanadidy. All rights reserved.
//

import Foundation
import UIKit

protocol Coordinator:AnyObject {
    var childCoordinators : [Coordinator] {get set}
    var navigationController : UINavigationController {get set}
    func start()
}
//protocol NavigationPerformActionDelegate {
//    func didPerformAction(with data:AnyObject)
//}




