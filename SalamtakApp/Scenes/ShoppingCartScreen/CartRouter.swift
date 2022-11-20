//
//  CartRouter.swift
//  Salamtak_App
//
//  Created by mostafa elsanadidy on 09.11.22.
//

import Foundation
import UIKit

typealias EntryCartPoint = UIViewController&AnyCartView
protocol AnyCartRouter:AnyRouter {
    var entry:EntryCartPoint? {get}
    var navigationController: UINavigationController? {set get}
    
     static func start() -> AnyCartRouter
    func stop()
    
}
class CartRouter: AnyCartRouter {
    var entry: EntryCartPoint?
    
    var navigationController: UINavigationController?
    
     static func start() -> AnyCartRouter {
         let recipeRouter = CartRouter()
        // assign viper
         let searchVC = ShoppingCartVC()
        var view:AnyCartView = searchVC
        var ViewModel:AnyCartViewModel = CartViewModel()
//        var interactor:AnyCartInteractor = CartInteractor()
        
        view.cartViewModel = ViewModel
//        ViewModel.view = view
//        ViewModel.interactor = interactor
        ViewModel.router = recipeRouter
//        interactor.ViewModel = ViewModel
        recipeRouter.entry = view as? EntryCartPoint
        
        return recipeRouter
    }
    func stop() {
        self.navigationController?.popViewController(animated: true)
    }
}
