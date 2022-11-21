//
//  MainCoordinator.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 21.11.22.
//  Copyright © 2022 mostafa elsanadidy. All rights reserved.
//

import Foundation
import UIKit


class MainCoordinator:NSObject,Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: UINavigationController
    
    init (navigationController: UINavigationController) {
    self.navigationController = navigationController
    }
    
    
    func start() {
        navigationController.delegate = self
        let vc = HomeVC()
        
//        let vc = ViewController. instantiate( )
        var view:AnyMedicationView = vc
        var ViewModel:AnyMedicationViewModel = MedicationViewModel()
//        var interactor:AnyMedicationInteractor = MedicationInteractor()
        
        view.homeViewModel = ViewModel
//        ViewModel.view = view
//        ViewModel.interactor = interactor
        ViewModel.coordinator = self
        navigationController.pushViewController(vc, animated: false)}
    
    func childShowCartItems(){
        let child = ShoppingCatCoordinator.init(navigationController: navigationController)
        //movies
//        child.data = movies as AnyObject
        child.parentCoordinator = self
        childCoordinators.append(child)
        child.start()
    }
    
    func childDidFinish( child: Coordinator?) {
        for (index, coordinator) in childCoordinators.enumerated() {
            if coordinator === child {
                childCoordinators.remove (at: index)
                break}
            }
        }
    }


extension MainCoordinator : UINavigationControllerDelegate {
    
    func navigationController (_ navigationController:
    UINavigationController, didShow viewController:
                               UIViewController, animated: Bool){
        guard let fromViewController = navigationController.transitionCoordinator?.viewController( forKey:.from) else{return}
        if navigationController.viewControllers.contains(fromViewController)
            {return}
        if let shoppingCartVC = fromViewController as? ShoppingCartVC{
            childDidFinish(child: shoppingCartVC.cartViewModel?.coordinator)}
    }
}
