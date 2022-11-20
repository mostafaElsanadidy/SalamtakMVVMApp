//
//  HomeVC.swift
//  Salamtak
//
//  Created by mostafa elsanadidy on 06.11.22.
//

import UIKit

protocol AnyMedicationView:AnyView{
    
    var homeViewModel: AnyMedicationViewModel? {get set}
//    func collectionViewDidLoad(isScrollToTop:Bool)
    
}

class HomeVC: UIViewController {

    var homeViewModel: AnyMedicationViewModel?
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var cartBttn: UIButton!
    @IBOutlet weak var cartInfoView: UIViewX!
    @IBOutlet weak var homeCollection : UICollectionView!
    
    @IBOutlet weak var searchBar : UISearchBar!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask))
        setupBinder()
        homeViewModel?.viewDidLoad()
    }

    
    func setupBinder(){
        homeViewModel?.tupleOf_totalPrice_arrOfItemsCount.bind{
            [weak self] tuple in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
                strongSelf.updateCountOfSelectedItems(numOfItems: tuple.arrOfItemsCount.reduce(0,+), totalPrice: tuple.totalPriceText)
            }
        }
//        homeViewModel?.isReloadCollection.bind{
//            [weak self] isReloadCollection in
//            guard let strongSelf = self else{return}
//            DispatchQueue.main.async{
//                strongSelf.collectionViewWillLoad()
//            }
//        }
        homeViewModel?.tupleOf_isScrollTag_isShowActivityView.bind{
            [weak self] tuple in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
//                strongSelf.collectionViewWillLoad()
                strongSelf.collectionViewDidLoad(isScrollToTop: tuple.isScrollToTop, isShowActivityView: tuple.isShowActivityView)
            }
        }
        homeViewModel?.isRefreshScreenTag.bind{
            [weak self] isRefreshScreenTag in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
                if isRefreshScreenTag{
                    strongSelf.loadMedications()}
            }
        }
        homeViewModel?.error.bind{
            [weak self] error in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
                strongSelf.update(with: error)
            }
        }
    }
        
    // MARK: - Setup Collection
    private func setup_Collection() {
        
        homeCollection.delegate = self
        homeCollection.dataSource = self
        homeCollection.register(UINib(nibName: "MedicationCell", bundle: nil), forCellWithReuseIdentifier: "MedicationCell")
    }

    @IBAction func checkoutOrder(_ sender: UIButton) {
        homeViewModel?.saveMedicines()
    }
    
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        
        homeViewModel?.changeLanguage()
    }
    @IBAction func routeToCartVC(_ sender: UIButton) {
        homeViewModel?.routeToNextVC()
    }
    
    func updateCountOfSelectedItems(numOfItems:Int,totalPrice:String){
        cartBttn.setTitle("\(numOfItems)", for: .normal)

        totalPriceLabel.text = totalPrice
        cartInfoView.isHidden = numOfItems <= 0
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        homeViewModel?.viewWillAppear()
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
    
    func collectionViewDidLoad(isScrollToTop:Bool, isShowActivityView:Bool){
            showActivityView(isShow: isShowActivityView)
        guard !isShowActivityView else {
            return
        }
            homeCollection.reloadData()
        if isScrollToTop{
            homeCollection.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        }
        }
    
//    func collectionViewWillLoad(){
//            showActivityView(isShow: true)
//    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if Int(distanceFromBottom) <= Int(height) { // when you reach the bottom
            homeViewModel?.appendGroupOfMedicines()
        }
    }
    
    func update(with error: Result_Error) {
        print(error.error_Desc)
    }
}
