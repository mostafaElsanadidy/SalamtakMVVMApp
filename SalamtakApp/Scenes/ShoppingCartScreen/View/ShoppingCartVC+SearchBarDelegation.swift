//
//  ShippingCartVC+SearchBarDelegation.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 20.11.22.
//

import Foundation
import UIKit

extension ShoppingCartVC:UISearchBarDelegate{
    
    
    func filterForSearchTextAndScopeButton(searchText:String) {
        
        medicinesTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            cartViewModel?.searchKey = searchText
    }
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

        guard let searchText = searchBar.text else{return}
        filterForSearchTextAndScopeButton(searchText: searchText)
        searchBar.showsCancelButton = false
        searchBar.endEditing(true)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.showsScopeBar = false
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterForSearchTextAndScopeButton(searchText: searchText)
    }
    
}
