//
//  HomeVC+Collection.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 19.11.22.
//

import Foundation
import UIKit

extension HomeVC:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return homeViewModel?.limit ?? 0
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let reuseIdentifier = "MedicationCell"
      
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? MedicationCell
        else{
            return UICollectionViewCell()
        }
        
        self.homeViewModel?.updateCellInfo(medicineIndex: indexPath.row){
            medicineContainer  in
            cell.nameLabel.text = medicineContainer.medicineNameText
            cell.priceLabel.text = medicineContainer.medicinePriceText
            if let sp_url = medicineContainer.medicinePicUrl{
                cell.medicineImageView.kf.indicatorType = .activity
                cell.medicineImageView.kf.setImage(with: sp_url)}
                
                cell.updateQuantityPrice={quantity,isFlag in
                    cell.addToCartView.isHidden = quantity > 0
                    cell.quantityStackView.isHidden = quantity <= 0
                    self.homeViewModel?.arrOfItemsCount[indexPath.row] = quantity
                }
                
                guard let count = self.homeViewModel?.arrOfItemsCount[indexPath.row] else {return}
                cell.addToCartView.isHidden = count > 0
                cell.quantityStackView.isHidden = count <= 0
                cell.quantityLabel.text = "\(count)"
        }
        
        
        return cell
    }
    
    
}


