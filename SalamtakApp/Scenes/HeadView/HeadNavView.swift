//
//  HeadNavView.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 21.11.22.
//

import Foundation
import UIKit
import Kingfisher


@IBDesignable
class HeadNavView : UIView {
    
    //Outlets
//    @IBOutlet weak var shareBttn: UIButton!
    @IBOutlet weak var backBttn: UIButton!
    @IBOutlet var containerView: UIView!
    @IBOutlet weak var searchBar : UISearchBar!
//    var sharedUrlString:String = ""
    
    // MARK: - AwakeFromNib
    override func awakeFromNib() {
        setup_Style()
    }
    
    // MARK: - INIT
      override init(frame: CGRect) {
          super.init(frame: frame)
          
          setupXib()
      }
      
      required init?(coder aDecoder : NSCoder) {
          super.init(coder: aDecoder)
          setupXib()
      }
    
    // MARK: - setupXib Border
       func setupXib() {
           let bundle = Bundle(for: type(of: self))
           let nibName = type(of: self).description().components(separatedBy: ".").last!
           let nib = UINib(nibName: nibName, bundle: bundle)
           
           // 1. Load the nib
           self.containerView = nib.instantiate(withOwner: self, options: nil).first as? UIView
           
           // 2. Set the bounds for the container view
           self.containerView.frame = bounds
           self.containerView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        
           // 3. Add this container view as the subview
           addSubview(containerView)
           initSearchBar()
           
       }
    
    // MARK: - Setup Style
    private func setup_Style() {
       
    }
    
    func initSearchBar() {
    
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.showsCancelButton = false
        searchBar.showsScopeBar = false
    }
    
    @IBAction func popToPreviousScreen(_ sender: UIButton) {
        ad.CurrentRootVC()?.popVCFromNav()
    }
    
//    @IBAction func shareRecipe(_ sender: UIButton) {
//        shareButtonPressed()
//    }
    //setting button's action

//    func shareButtonPressed(){
//
//        //checking the object and the link you want to share
//
//
//        let linkToShare = [sharedUrlString]
//
//        let activityController = UIActivityViewController(activityItems: linkToShare, applicationActivities: nil)
//
//        ad.CurrentRootVC()?.present(activityController, animated: true, completion: nil)
//
//    }
    //MARK: - imgAction
    @objc func imgAction(){
    // perform the action here
    }

}
