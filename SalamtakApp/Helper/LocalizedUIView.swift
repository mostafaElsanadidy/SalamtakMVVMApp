//
//  Card View.swift
//  MadeInKuwait
//
//  Created by Amir on 2/6/20.
//  Copyright © 2020 Amir. All rights reserved.
//

import UIKit
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

