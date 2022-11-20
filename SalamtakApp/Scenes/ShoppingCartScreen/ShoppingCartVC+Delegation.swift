//
//  ShoppingCartVC+Delegation.swift
//  CheeseBurgerApp
//
//  Created by mostafa elsanadidy on 22.08.22.
//

import Foundation
import UIKit
import SwipeCellKit

extension ShoppingCartVC:UITableViewDelegate,SwipeTableViewCellDelegate{
    
    // MARK: - Cell Size
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        guard orientation == .right else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
            // handle action by updating model with deletion
            action.fulfill(with: .delete)
            self.presenter?.deleteItems(at: indexPath.row)
            
        }
        // customize the action appearance
        deleteAction.image = UIImage(named: "delete")

        return [deleteAction]
    }
    
    func tableView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.expansionStyle = .destructive
        options.transitionStyle = .drag
        return options
    }
    
    // count of selectedCellsArr/insertedRows
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
    
    func tableView(_tableView: UITableView,indentationLevelForRowAt indexPath: IndexPath)-> Int{


        let newIndexPath = IndexPath(row: 0, section: 0)
//    }
        return tableView(_tableView: medicinesTableView,indentationLevelForRowAt: newIndexPath)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {

        return UITableView.automaticDimension
   
    }

     func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
       
         return UITableView.automaticDimension
    }
}

