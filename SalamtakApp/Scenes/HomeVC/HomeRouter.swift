//
//  Router.swift
//  Salamtak
//
//  Created by mostafa elsanadidy on 06.11.22.
//

import Foundation
import UIKit
// object
// Entry point


typealias EntryMedicationPoint = UIViewController&AnyMedicationView
protocol AnyRouter{
    var navigationController: UINavigationController? {set get}
}

protocol AnyMedicationRouter:AnyRouter{
    
    var entry:EntryMedicationPoint? {get}
     static func start() -> AnyMedicationRouter
//    func stop()
    func route(to destination:AnyCartRouter)
//    that's why the ViewModel holds on to router
}

class MedicationRouter: AnyMedicationRouter {
    
    func route(to destination: AnyCartRouter) {
        var router = destination
        let initialVC = router.entry
        let viewController = initialVC
        navigationController?.pushViewController(viewController ?? ShoppingCartVC(), animated: true)
        router.navigationController = navigationController
    }
    
    
    var entry: EntryMedicationPoint?
    
    var navigationController: UINavigationController?
    
     static func start() -> AnyMedicationRouter {
         let recipeRouter = MedicationRouter()
        // assign viper
         let searchVC = HomeVC()
        var view:AnyMedicationView = searchVC
        var ViewModel:AnyMedicationViewModel = MedicationViewModel()
//        var interactor:AnyMedicationInteractor = MedicationInteractor()
        
        view.homeViewModel = ViewModel
//        ViewModel.view = view
//        ViewModel.interactor = interactor
        ViewModel.router = recipeRouter
//        interactor.ViewModel = ViewModel
        recipeRouter.entry = view as? EntryMedicationPoint
        return recipeRouter
    }
    
   
}
