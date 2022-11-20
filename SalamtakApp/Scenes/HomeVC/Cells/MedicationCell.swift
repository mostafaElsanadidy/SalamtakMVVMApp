//
//  MedicationCell.swift
//  Salamtak
//
//  Created by mostafa elsanadidy on 06.11.22.
//

import UIKit

class MedicationCell: UICollectionViewCell {

    @IBOutlet weak var medicineImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var quantityStackView: UIStackView!
    @IBOutlet weak var addToCartView: UIViewX!
    @IBOutlet weak var plusBttn: UIButtonX!
    @IBOutlet weak var minusBttn: UIButton!
    var isPlusBttnClickedflag:Bool = true
    var numOfItems = 0{
        didSet{
            quantityLabel.text = "\(numOfItems)"
            updateQuantityPrice?(numOfItems, isPlusBttnClickedflag)
        }
    }
    
    var updateQuantityPrice : ((_ quantity:Int, _ isPlusBttnClickedflag:Bool) -> ())!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        addToCartView.isUserInteractionEnabled = true
        addToCartView.addGestureRecognizer(tapGestureRecognizer)
        
        }

        @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
        {
            // Your action
            plusBttnDidTapped(plusBttn)
        }
    
    override func prepareForReuse() {
    
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
        sender.isUserInteractionEnabled = numOfItems != 0
    }
    
}
