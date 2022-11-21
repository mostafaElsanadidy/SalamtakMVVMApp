//
//  Storyboarded.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 21.11.22.
//  Copyright © 2022 mostafa elsanadidy. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboarded{
    static func instantiate() -> Self
}

extension Storyboarded where Self:UIViewController {
    
    static func instantiate() -> Self{
    let id = String(describing: self)
    let storyboard = UIStoryboard(name: "Main", bundle:
    Bundle.main)
    return storyboard.instantiateViewController(withIdentifier:
                                                    id) as! Self
        
    }
}
