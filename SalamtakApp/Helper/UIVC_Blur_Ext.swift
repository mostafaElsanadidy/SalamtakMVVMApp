//
//  UIVC_Blur_Ext.swift
//  Zawidha
//
//  Created by Maher on 10/6/20.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController {
    
    
    func set_Blur(containerView : UIView) {
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.alpha = 0.9
        blurEffectView.frame = containerView.frame
        containerView.insertSubview(blurEffectView, at: 0)
    }
    
    // MARK: - Animate In
     func animateIN(animation:@escaping ()->()) {
                    UIView.animateKeyframes(withDuration: 0.3, delay: 0.15, animations: animation)
        }
        
        // MARK: - Animate Out
     func animateOut(animation:@escaping ()->(),completion:@escaping (Bool)->()) {
            
            UIView.animateKeyframes(withDuration: 0.3, delay: 0, options: .beginFromCurrentState, animations: animation
                , completion: completion)
        }
    
    
    func showActivityView(isShow:Bool, tag:Int = 1000) {
        if isShow{
                   self.loading()
               }else{
                   self.killLoading()
               }
//        if isShow{
//           // UIApplication.shared.isNetworkActivityIndicatorVisible = true
//
//          //  let ind = MyIndicator(frame: CGRect(x: self.view.bounds.midX - 25, y: self.view.bounds.midY - 25, width: 50, height: 50), image: UIImage(named: "Ellipse 66") ?? UIImage())
//            let ind2 = MyIndicator(frame: CGRect(x: self.view.bounds.midX - 25, y: self.view.bounds.midY - 25, width: 50, height: 50), image: UIImage(named: "Group 1532") ?? UIImage())
//           // view.addSubview(ind)
//            view.addSubview(ind2)
//            ind2.startAnimating()
//            //ind.startAnimating()
//           // ind.tag = tag
//            ind2.tag = tag+1
//           // self.loading()
//        }else{
//          //  UIApplication.shared.isNetworkActivityIndicatorVisible = false
//           // self.view.viewWithTag(tag)?.removeFromSuperview()
//            self.view.viewWithTag(tag+1)?.removeFromSuperview()
//           // self.killLoading()
//        }
    }
    
    
    func fixOrientation(img: UIImage) -> UIImage {
        if (img.imageOrientation == .up) {
            return img
        }

        UIGraphicsBeginImageContextWithOptions(img.size, false, img.scale)
        let rect = CGRect(x: 0, y: 0, width: img.size.width, height: img.size.height)
        img.draw(in: rect)

        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return normalizedImage
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
