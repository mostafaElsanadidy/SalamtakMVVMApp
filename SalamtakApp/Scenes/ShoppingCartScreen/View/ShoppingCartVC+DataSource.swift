//
//  ShoppingCartVC+DataSource.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 20.11.22.
//

import Foundation
import UIKit

extension ShoppingCartVC:UITableViewDataSource{


    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartViewModel?.limit ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reuseIdentifier = "ShoppingCartCell"

        guard let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ShoppingCartCell
        else{
            return UITableViewCell()
        }
            
        self.cartViewModel?.updateCellInfo(medicineIndex: indexPath.row){
            medicineContainer  in
            cell.nameLabel.text = medicineContainer.medicineNameText
            cell.priceLabel.text = medicineContainer.medicinePriceText
            if let sp_url = medicineContainer.medicinePicUrl{
                cell.medicineImageView.kf.indicatorType = .activity
                cell.medicineImageView.kf.setImage(with: sp_url)}
            
            cell.updateQuantityPrice={quantity,isFlag in
               self.cartViewModel?.arrOfItemsCount[indexPath.row] = quantity
                if quantity == 0{
                    self.cartViewModel?.deleteItems(at: indexPath.row)
                }else{
                    self.cartViewModel?.updateMedicine(at: indexPath.row, with: quantity)}
            
            }
            let count = self.cartViewModel?.arrOfItemsCount[indexPath.row]

                        cell.quantityLabel.text = "\(count ?? 0)"
                cell.deleteItemFromCart = {self.cartViewModel?.deleteItems(at: indexPath.row)}
            
            
        }
       
//        if let medicine = self.ViewModel?.medicines[indexPath.row]{
//
//                cell.nameLabel.text = "lang".localized == "en" ? medicine.enName : medicine.arName
//            
//                let originalUrl = (medicine.picUrl ?? "")
//                let updatedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
//                 if let sp_url = URL(string: updatedUrl ?? "")
//                {
//                    cell.medicineImageView.kf.indicatorType = .activity
//                    cell.medicineImageView.kf.setImage(with: sp_url)}
//
//        }
        
        return cell
    }

}
