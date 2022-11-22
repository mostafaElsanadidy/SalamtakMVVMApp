//
//  HomeVC.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 19.11.22.
//

import UIKit

protocol AnyMedicationView:AnyView{
    
//    func initialState(viewModel:AnyMedicationViewModel)
    var homeViewModel: AnyMedicationViewModel? {get set}

}

class HomeVC: UIViewController {
    
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var cartBttn: UIButton!
    @IBOutlet weak var cartInfoView: UIViewX!
    @IBOutlet weak var homeCollection : UICollectionView!
    @IBOutlet weak var headView: HeadNavView!
    
     var homeViewModel: AnyMedicationViewModel?
//    func initialState(viewModel:AnyMedicationViewModel) {
//        self.homeViewModel = viewModel
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        print(FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask))
        setupBinder()
        homeViewModel?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        homeViewModel?.viewWillAppear()
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
        cartBttn.setTitle("\(numOfItems)".localized, for: .normal)

        totalPriceLabel.text = totalPrice
        cartInfoView.isHidden = numOfItems <= 0
    }
    
    
  
    
    func setupBinder(){
        homeViewModel?.tupleOf_totalPrice_arrOfItemsCount.bind{
            [weak self] tuple in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
                strongSelf.updateCountOfSelectedItems(numOfItems: tuple.arrOfItemsCount.reduce(0,+), totalPrice: tuple.totalPriceText)
            }
        }
        homeViewModel?.accessCoreDataSuccessState.bind{
            [weak self] coreDataSuccessState in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
                if coreDataSuccessState == .create{
                    strongSelf.show_Popup(body: "Success Saving", type: .single, status: .success)}
            }
            if coreDataSuccessState == .update{
                strongSelf.show_Popup(body: "Success Updating", type: .single, status: .success)}
        }
        
        
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
        headView.backBttn.isHidden = true
        setup_Collection()
//        initSearchBar()
        headView.searchBar.delegate = self
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
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if Int(distanceFromBottom) <= Int(height) { // when you reach the bottom
            homeViewModel?.appendGroupOfMedicines()
        }
        if contentYoffset == .zero{
            homeViewModel?.reloadCollection()
        }
    }
    
    func update(with error: Result_Error) {
        print(error.error_Desc)
    }
}
