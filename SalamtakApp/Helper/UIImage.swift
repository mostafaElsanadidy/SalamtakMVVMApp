//
//  UIImage.swift
//  MadeInKuwait
//
//  Created by Amir on 2/7/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIView.ContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage

        let size = self.size
        let aspectRatio =  size.width/size.height

        switch contentMode {
            case .scaleAspectFit:
                if aspectRatio > 1 {                            // Landscape image
                    width = dimension
                    height = dimension / aspectRatio
                } else {                                        // Portrait image
                    height = dimension
                    width = dimension * aspectRatio
                }

        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }

        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
                newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }

        return newImage
    }
    
}


extension UIImageView{
    
    func DownloadImage(withUrl urlStr:String){
              let url = URL(string: urlStr)
                 let processor = DownsamplingImageProcessor(size: self.bounds.size)
                 self.kf.indicatorType = .activity
                 self.kf.setImage(
                     with: url,
                     placeholder: UIImage(named: "placeholderImage"),
                     options: [
                         .processor(processor),
                         .scaleFactor(UIScreen.main.scale),
                         .transition(.fade(1)),
                         .cacheOriginalImage
                     ])
                 {
                     result in
                     switch result {
                     case .success(let value):
                         print("Task done for: \(value.source.url?.absoluteString ?? "")")
                     case .failure(let error):
                         print("Job failed: \(error.localizedDescription)")
                     }
                 }
          }
}
