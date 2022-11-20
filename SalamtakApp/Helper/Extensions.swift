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
    
   func showAlert(title:String , message : String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "ok".localized, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
      }
    
    func showAlert() {
        let alert = UIAlertController(title: "Warning!".localized, message: "Connection Server Failed".localized, preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil))
           self.present(alert, animated: true, completion: nil)
       }
    
    func showAlertAndBack(title:String, message:String){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
            NSLog("OK Pressed")}
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func showAlertPOP(title:String, message:String){
         let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
         let okAction = UIAlertAction(title: "OK".localized, style: UIAlertAction.Style.default) {
             UIAlertAction in
             self.dismiss(animated: true, completion: nil)
             self.navigationController?.popToRootViewController(animated: true)
             NSLog("OK Pressed")}
         alertController.addAction(okAction)
         self.present(alertController, animated: true, completion: nil)
     }
    
    func goTo (identifier : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: identifier)
        self.navigationController?.pushViewController(destVC, animated: true)
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
    
    func nextPresent(identifier : String) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let destVC = storyboard.instantiateViewController(withIdentifier: identifier)
        self.present(destVC, animated: true, completion: nil)
    }
    
//    func loading(activityIndicatorView: inout NVActivityIndicatorView?){
//        let color = UIColor(red: 52/255.0, green: 87/255.0, blue: 183/255.0, alpha: 1.0)
//       let boxWidth: CGFloat = 96
//       let boxHeight: CGFloat = 96
//       let boxRect = CGRect(
//        x: round((self.view.bounds.size.width - boxWidth) / 2),
//        y: round((self.view.bounds.size.height - boxHeight) / 2),
//       width: boxWidth,
//       height: boxHeight)
//       activityIndicatorView = NVActivityIndicatorView.init(frame: boxRect, type: .ballTrianglePath, color: color, padding: nil)
//
//       activityIndicatorView?.startAnimating()
//    }
    
//    func killLoading(activityIndicatorView: inout NVActivityIndicatorView?){
//        activityIndicatorView?.stopAnimating()
//    }
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
    
    func isPhone () -> Bool {
        if  (self.rangeOfCharacter(from: NSCharacterSet.decimalDigits) == nil) || self.count != 8 {
            return false
            
        }else {
            return true
        }
    }
    
    
    func isValidName(name:String) -> Bool {
         let nameRegex = "\\w{4,18}"
         let namePredicate = NSPredicate(format:"SELF MATCHES %@", nameRegex)
         return namePredicate.evaluate(with: name)
     }
     
     func isValidPassword(pass: String) -> Bool {
         if pass.count < 8 {
             return false
         } else {
             return true
         }
     }
}

extension UIViewController {

    func saveUserData(name:String , phone:String , userid:Int) {
        NetworkHelper.name = name
        NetworkHelper.phone = phone
        NetworkHelper.userID = userid
    }
    
}
