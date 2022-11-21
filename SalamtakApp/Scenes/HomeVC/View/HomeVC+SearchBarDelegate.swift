//
//  HomeVC+SearchBarDelegate.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 19.11.22.
//

import Foundation
import UIKit
//import DropDown

extension HomeVC:UISearchBarDelegate{
    
    
    func filterForSearchTextAndScopeButton(searchText:String) {
        
        homeCollection.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        
        if searchText != ""{
            homeViewModel?.searchKey = searchText
            homeViewModel?.appendGroupOfMedicines()
        }
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
    
    }
    
}
