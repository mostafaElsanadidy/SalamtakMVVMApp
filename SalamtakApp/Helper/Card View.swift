//
//  Card View.swift
//  MadeInKuwait
//
//  Created by Amir on 2/6/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 5
    @IBInspectable var shadowOffsetWidth: Int = 1
    @IBInspectable var shadowOffsetHeight: Int = 1
    @IBInspectable var shadowColor: UIColor? = UIColor.lightGray
    @IBInspectable var shadowOpacity: Float = 0.5
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
}

import MOLH


class LocalizedUIButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }
    
    
    func common(){
        self.transform = MOLHLanguage.isArabic() ? CGAffineTransform.init(rotationAngle: .pi) : .identity
    }
}

class LocalizedUIImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        common()
    }
    
    
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        common()
    }
    
    
    func common(){
        self.transform = MOLHLanguage.isArabic() ? CGAffineTransform.init(rotationAngle: .pi) : .identity
    }
}

