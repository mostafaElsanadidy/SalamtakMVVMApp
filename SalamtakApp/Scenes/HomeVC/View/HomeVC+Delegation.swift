//
//  HomeVC+Delegation.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 19.11.22.
//

import Foundation
import UIKit


extension HomeVC:UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    // MARK: - Cell Size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        
        var numberOfItemsInRow,edgeInset:CGFloat
        var heightPerItem:CGFloat = 0
            heightPerItem = 250
            edgeInset = 0
            numberOfItemsInRow = 1
        
        let paddingSpace = edgeInset*(numberOfItemsInRow+1)
        let availableWidth = collectionView.frame.size.width-paddingSpace
        let widthPerItem = availableWidth/numberOfItemsInRow
        
        homeViewModel?.updateCellSize(medicineIndex: indexPath.row, widthForItem: widthPerItem, cellSizeHandler: {
            height in
            heightPerItem = height
        })
        
        return CGSize(width: widthPerItem,height: heightPerItem)
      }


    // MARK: - Insets
    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }


    func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       // to know usage of this method change scroll direction of OptionCollection to Vertical instead of Horizental
        return 150
    }
}


