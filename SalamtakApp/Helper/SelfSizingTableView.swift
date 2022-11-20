//
//  SelfSizingTableView.swift
//  Salamtak_App
//
//  Created by mostafa elsanadidy on 09.11.22.
//

import UIKit

class SelfSizingTableView: UITableView {

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
 //        Drawing code
    }
    
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
     
     override func reloadData() {
       super.reloadData()
       self.invalidateIntrinsicContentSize()
       self.layoutIfNeeded()
     }
     
     override var intrinsicContentSize: CGSize {
         setNeedsLayout()
           layoutIfNeeded()
       let height = min(contentSize.height, maxHeight)
       return CGSize(width: contentSize.width, height: height)
     }

}
