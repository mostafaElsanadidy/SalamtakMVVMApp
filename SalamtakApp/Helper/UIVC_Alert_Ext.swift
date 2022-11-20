//
//  UIVC_Alert_Ext.swift
//  Zawidha
//
//  Created by Maher on 10/12/20.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable{
    
//    func show_Popup (title : String = "" , body : String , okBtnTitle:String = "" , type : Alert_Type , status : Alert_Status , completionHandler : ((Bool)->())? = nil ) {
//        let vc = AlertVC()
//        if title.isEmpty == true{
//            if status == .failure {
//                vc.alert_Title = "حدث خطأ"
//                vc.emojiImageName = "grimacing"
//                vc.okBtnTitle = okBtnTitle
//                if okBtnTitle == ""{
//                    vc.okBtnTitle = "العودة"}
//            } else {
//                vc.alert_Title = "تمت العملية بنجاح"
//                vc.emojiImageName = "emoji-5"
//                vc.okBtnTitle = okBtnTitle
//                if okBtnTitle == ""{
//                    vc.okBtnTitle = "انطلق"}
//            }
//        } else {
//            if title == "no internet connection"{
//                vc.alert_Title = "لا يوجد إتصال"
//                vc.alert_Body = body
//                vc.yesOptionalTypeBttnText = "إعادة المحاولة"
//                vc.noOptionalTypeBttnText = "إلغاء"
////                vc.noOptionalTypeBttn.setTitle("إلغاء", for: .normal)
////                vc.yesOptionalTypeBttn.setTitle("إعادة المحاولة", for: .normal)
//                vc.emojiImageName = "suspicious"
//            }
//           // vc.alert_Title = title
//        }
//        vc.alert_Body = body
//        vc.alert_Type = type
//        vc.alert_Status = status
//        vc.completionHandler = completionHandler
//        vc.modalPresentationStyle = .overFullScreen
//        vc.modalTransitionStyle = .crossDissolve
//        DispatchQueue.main.async {[weak self] in
//            self?.present(vc, animated: true, completion: nil)
//        }
//    }
    
    
    func loading(){
         let color = UIColor(red: 52/255.0, green: 87/255.0, blue: 183/255.0, alpha: 1.0)
        
         startAnimating(nil, message: nil, messageFont: nil, type: .ballTrianglePath, color: color , padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: .clear, textColor: nil, fadeInAnimation: nil)
        
     }
     
     func killLoading(){
         stopAnimating()
     }
    
    
    func resizeImage(image: UIImage?, targetSize: CGSize) -> UIImage? {
        let size = image?.size
        let width = (size?.width ?? 0)
        let height = (size?.height ?? 0)

        let widthRatio  = targetSize.width  / width
        let heightRatio = targetSize.height / height

       // Figure out what our orientation is, and use that to form the rectangle
       var newSize: CGSize
       if(widthRatio > heightRatio) {
           newSize = CGSize(width: width * heightRatio, height: height * heightRatio)
       } else {
           newSize = CGSize(width: width * widthRatio,  height: height * widthRatio)
       }

       // This is the rect that we've calculated out and this is what is actually used below
       let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)

       // Actually do the resizing to the rect using the ImageContext stuff
       UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image?.draw(in: rect)
       let newImage = UIGraphicsGetImageFromCurrentImageContext()
       UIGraphicsEndImageContext()

       return newImage
   }
}
