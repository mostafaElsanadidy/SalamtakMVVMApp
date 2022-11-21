//
//  ShoppingCartCell.swift
//  SalamtakApp 
//
//  Created by mostafa elsanadidy on 20.11.22.
//

import UIKit
import SwipeCellKit

class ShoppingCartCell: SwipeTableViewCell{

    
    @IBOutlet weak var quantityView: UIView!


        @IBOutlet weak var medicineImageView: UIImageView!
        @IBOutlet weak var nameLabel: UILabel!
        @IBOutlet weak var priceLabel: UILabel!
        @IBOutlet weak var quantityLabel: UILabel!
        @IBOutlet weak var plusBttn: UIButtonX!
        @IBOutlet weak var minusBttn: UIButton!
        var isPlusBttnClickedflag:Bool = true
        var numOfItems = 0{
            didSet{
                quantityLabel.text = "\(numOfItems)"
//                print(numOfItems)
                updateQuantityPrice?(numOfItems, isPlusBttnClickedflag)
            }
        }
        
        var updateQuantityPrice : ((_ quantity:Int, _ isPlusBttnClickedflag:Bool) -> ())!
    var deleteItemFromCart : (() -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
       
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
    
    }
    
    @IBAction func deleteItemFromCart(_ sender: UIButtonX) {
        self.deleteItemFromCart()
    }
    @IBAction func plusBttnDidTapped(_ sender: UIButton) {

        isPlusBttnClickedflag = true
        
        let count = Int(quantityLabel.text ?? "")
        let orderAmount = count != nil ? count : 0
        numOfItems = orderAmount! + 1
        self.minusBttn.isUserInteractionEnabled = numOfItems > 0
    }
    
    @IBAction func minusBttnDidTapped(_ sender: UIButton) {
        
        isPlusBttnClickedflag = false
        let count = Int(quantityLabel.text ?? "")
        let orderAmount = count != nil ? count : 0
        numOfItems = orderAmount! > 0 ? orderAmount! - 1 : orderAmount!
//        print(numOfItems)
        sender.isUserInteractionEnabled = numOfItems != 0
    }
    
}
