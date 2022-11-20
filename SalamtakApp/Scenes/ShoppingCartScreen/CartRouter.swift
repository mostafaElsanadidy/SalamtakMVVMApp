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
    
}
class CartRouter: AnyCartRouter {
    var entry: EntryCartPoint?
    
    var navigationController: UINavigationController?
    
     static func start() -> AnyCartRouter {
         let recipeRouter = CartRouter()
        // assign viper
         let searchVC = ShoppingCartVC()
        var view:AnyCartView = searchVC
        var presenter:AnyCartPresenter = CartPresenter()
        var interactor:AnyCartInteractor = CartInteractor()
        
        view.presenter = presenter
        presenter.view = view
        presenter.interactor = interactor
        presenter.router = recipeRouter
        interactor.presenter = presenter
        recipeRouter.entry = view as? EntryCartPoint
        
        return recipeRouter
    }
}
