//
//  ShoppingCartVC.swift
//  CheeseBurgerApp
//
//  Created by mostafa elsanadidy on 22.08.22.
//

import UIKit

protocol AnyView {
    func loadMedications()
    func collectionViewDidLoad(isScrollToTop:Bool)
    func collectionViewWillLoad()
    func update(with error: Result_Error)
    func updateCountOfSelectedItems(numOfItems:Int,totalPrice:String)
}

protocol AnyCartView:AnyView{
    
    var presenter: AnyCartPresenter? {get set}
}

class ShoppingCartVC: UIViewController {
    
    @IBOutlet weak var medicinesTableView: SelfSizingTableView!
    @IBOutlet weak var medicinesTable_View: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var shippingFeedsLabel: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var totalPriceView: UIViewX!


    var presenter: AnyCartPresenter?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        presenter?.viewDidLoad()
    }
    
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        
        presenter?.changeLanguage()
        
    }
    func updateCountOfSelectedItems(numOfItems:Int,totalPrice:String){
        orderAmountLabel.text = "\(numOfItems)x"
        totalPriceLabel.text = totalPrice 
        
        shippingFeedsLabel.text = "It varies according to the region".localized
        
    }

    // MARK: - Setup Collection
    private func setup_Collection() {
        
        medicinesTableView.dataSource = self
        medicinesTableView.delegate = self
        medicinesTableView.register(UINib(nibName: "ShoppingCartCell", bundle: nil), forCellReuseIdentifier: "ShoppingCartCell")
        
    }
    
    func initSearchBar() {
    
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.showsCancelButton = false
        searchBar.showsScopeBar = false
//        searchBar.scopeButtonTitles = searchBarFilters
        searchBar.delegate = self
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func didCardBttnTapped(_ sender: UIButton) {
        
        self.medicinesTableView.reloadData()
        medicinesTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
    }
    
    @IBAction func didReturnBttnTapped(_ sender: UIButton) {
        self.popVCFromNav()
    }

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


extension ShoppingCartVC:AnyCartView{
    
    func loadMedications() {
        setup_Collection()
        initSearchBar()
    }
    
    func collectionViewDidLoad(isScrollToTop:Bool){
            
        showActivityView(isShow: false)
        
           medicinesTableView.reloadData()
        medicinesTable_View.isHidden = (presenter?.limit ?? 0) == 0
        totalPriceView.isHidden = (presenter?.limit ?? 0) == 0
        
        if isScrollToTop{
            medicinesTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)}
        
        }
    
    func collectionViewWillLoad(){

            showActivityView(isShow: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if Int(distanceFromBottom) <= Int(height) { // when you reach the bottom
            presenter?.appendGroupOfMedicines()
        }
    }
    
    func update(with error: Result_Error) {
//        print(error.error_Desc)
    }
    

}
