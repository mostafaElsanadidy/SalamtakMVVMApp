//
//  ShoppingCartCoordinator.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 21.11.22.
//

import Foundation
import UIKit


class ShoppingCatCoordinator:Coordinator{
   
    weak var parentCoordinator : MainCoordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    
    init (navigationController: UINavigationController) {
    self.navigationController = navigationController
    }
    
    
    func start(){
//        navigationController.delegate = self
        let vc = ShoppingCartVC()
        
//        let vc = ViewController. instantiate( )
        var view:AnyCartView = vc
        var ViewModel:AnyCartViewModel = CartViewModel()
//        var interactor:AnyMedicationInteractor = MedicationInteractor()
        
        view.cartViewModel = ViewModel
//        ViewModel.view = view
//        ViewModel.interactor = interactor
        ViewModel.coordinator = self
        navigationController.pushViewController(vc, animated: true)}
    
//    func showMoreMovies(with movies:[Movie_VM]){
//        self.data = movies as AnyObject
//    }
    
//    func didFinishSearching() {
//        parentCoordinator?.childDidFinish(child: self)
//    }
    
    func stop() {
        self.navigationController.popViewController(animated: true)
        }
}
