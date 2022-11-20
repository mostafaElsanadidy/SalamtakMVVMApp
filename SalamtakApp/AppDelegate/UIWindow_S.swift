//
//  UIWindow_S.swift
//  CheeseBurgerApp
//
//  Created by mostafa elsanadidy on 16.08.22.
//

import Foundation
import UIKit

// MARK: - AD Current
/** @abstract UIWindow hierarchy category.  */
public extension UIWindow {
    
    /** @return Returns the current Top Most ViewController in hierarchy.   */
    func topMostWindowController()->UIViewController? {
        
        var topController = rootViewController
        
        while let presentedController = topController?.presentedViewController {
            topController = presentedController
        }
        
        return topController
    }
    
    /** @return Returns the topViewController in stack of topMostWindowController.    */
    func currentViewController()->UIViewController? {
        
        var currentViewController = topMostWindowController()
        
        while currentViewController != nil && currentViewController is UINavigationController && (currentViewController as! UINavigationController).topViewController != nil {
            currentViewController = (currentViewController as! UINavigationController).topViewController
        }
        return currentViewController
    }
}
