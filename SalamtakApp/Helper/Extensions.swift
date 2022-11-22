//
//  Extensions.swift
//  MadeinKW-Driver
//
//  Created by Amir on 4/17/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


extension UIViewController{
 
    func showAlertAndBack(title:String, message:String,isReturnToPreviousScreen:Bool = true,completion:((UIAlertAction) -> Void)? = nil){
        let alertController = UIAlertController(title: title.localized, message: message.localized, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default) {
            UIAlertAction in
            guard completion != nil else{return}
            self.dismiss(animated: true, completion: nil)
            if isReturnToPreviousScreen{
                self.navigationController?.popViewController(animated: true)}else{
                    self.navigationController?.popToRootViewController(animated: true)}
            NSLog("OK Pressed")}
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }

    
    func goTo (identifier : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(destVC, animated: true)
    }
    
    func nextPresent(identifier : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: identifier)
        self.present(destVC, animated: true, completion: nil)
    }
    
    func pushViewController(id:String = "" , VC:UIViewController! = nil){
      
        if VC != nil{
            self.navigationController?.pushViewController(VC , animated: true)
        }else if id != ""{
        let homeVC = self.storyboard!.instantiateViewController(withIdentifier :id)
        //present(homeVC, animated: true, completion: nil)
            self.navigationController?.pushViewController(homeVC , animated: true)}
    }
    
    
    @objc func popVCFromNav(){
        
    self.navigationController?.popViewController(animated: true)
    }
    
}


extension String {
    
    func sizeOfString (constrainedToWidth width: CGFloat, font:UIFont) -> CGSize {
        return NSString(string: self).boundingRect(
            with: CGSize(width: width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil).size
    }
    
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

extension UIViewController {

    func saveUserData(name:String , phone:String , userid:Int) {
        NetworkHelper.name = name
//        NetworkHelper.phone = phone
//        NetworkHelper.userID = userid
    }
    
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}


import NVActivityIndicatorView

extension UIViewController {
//
//
    func set_Blur(containerView : UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = containerView.frame
        containerView.insertSubview(blurEffectView, at: 0)
    }
    func showActivityView(isShow:Bool, tag:Int = 1000) {
        if isShow{
                   self.loading()
               }else{
                   self.killLoading()
               }
    }
}
