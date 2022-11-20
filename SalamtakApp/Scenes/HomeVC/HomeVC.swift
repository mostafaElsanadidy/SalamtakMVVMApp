//
//  HomeVC.swift
//  Salamtak
//
//  Created by mostafa elsanadidy on 06.11.22.
//

import UIKit

protocol AnyMedicationView:AnyView{
    
    var presenter: AnyMedicationPresenter? {get set}
//    func collectionViewDidLoad(isScrollToTop:Bool)
    
}

class HomeVC: UIViewController {

    var presenter: AnyMedicationPresenter?
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var cartBttn: UIButton!
    @IBOutlet weak var cartInfoView: UIViewX!
    @IBOutlet weak var homeCollection : UICollectionView!
    
    @IBOutlet weak var searchBar : UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask))
        presenter?.viewDidLoad()
    }

    // MARK: - Setup Collection
    private func setup_Collection() {
        
        homeCollection.delegate = self
        homeCollection.dataSource = self
        homeCollection.register(UINib(nibName: "MedicationCell", bundle: nil), forCellWithReuseIdentifier: "MedicationCell")
    }

    @IBAction func checkoutOrder(_ sender: UIButton) {
        presenter?.saveMedicines()
    }
    
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        
        presenter?.changeLanguage()
    }
    @IBAction func routeToCartVC(_ sender: UIButton) {
        presenter?.routeToNextVC()
    }
    
    func updateCountOfSelectedItems(numOfItems:Int,totalPrice:String){
        cartBttn.setTitle("\(numOfItems)", for: .normal)

        totalPriceLabel.text = totalPrice
        cartInfoView.isHidden = numOfItems <= 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func initSearchBar() {
    
        searchBar.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = UIReturnKeyType.done
        searchBar.showsCancelButton = false
        searchBar.showsScopeBar = false
        searchBar.delegate = self
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
extension HomeVC:AnyMedicationView{
    func loadMedications() {
        setup_Collection()
        initSearchBar()
    }
    
    func collectionViewDidLoad(isScrollToTop:Bool){
            showActivityView(isShow: false)
            homeCollection.reloadData()
        if isScrollToTop{
            homeCollection.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
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
        print(error.error_Desc)
    }
}
