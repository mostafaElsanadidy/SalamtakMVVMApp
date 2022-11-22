//
//  ShoppingCartVC.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 20.11.22.
//

import UIKit

protocol AnyView {

}

protocol AnyCartView:AnyView{
    
    var cartViewModel: AnyCartViewModel? {get set}
}

class ShoppingCartVC: UIViewController {
    
    @IBOutlet weak var headView: HeadNavView!
    @IBOutlet weak var medicinesTableView: SelfSizingTableView!
    @IBOutlet weak var medicinesTable_View: UIView!
    @IBOutlet weak var totalPriceLabel: UILabel!
    @IBOutlet weak var shippingFeedsLabel: UILabel!
    @IBOutlet weak var orderAmountLabel: UILabel!
//    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var totalPriceView: UIViewX!

    internal var cartViewModel : AnyCartViewModel?
//    func initialState(viewModel:AnyCartViewModel) {
//        self.cartViewModel = viewModel
//    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupBinder()
        cartViewModel?.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        cartViewModel?.viewWillAppear()
    }
    
    func setupBinder(){
        cartViewModel?.tupleOf_totalPrice_arrOfItemsCount.bind{
            [weak self] tuple in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
                strongSelf.updateCountOfSelectedItems(numOfItems: tuple.arrOfItemsCount.reduce(0,+), totalPrice: tuple.totalPriceText)
            }
        }
        cartViewModel?.accessCoreDataSuccessState.bind{
            [weak self] coreDataSuccessState in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
                if coreDataSuccessState == .create{
                    strongSelf.show_Popup(body: "Success Saving", type: .single, status: .success)}
            }
            if coreDataSuccessState == .update{
                strongSelf.show_Popup(body: "Success Updating", type: .single, status: .success)}
        }
        cartViewModel?.tupleOf_isScrollTag_isShowActivityView.bind{
            [weak self] tuple in
            guard let strongSelf = self else{return}
           
                strongSelf.collectionViewDidLoad(isScrollToTop: tuple.isScrollToTop, isShowActivityView: tuple.isShowActivityView)
            
        }
        cartViewModel?.isRefreshScreenTag.bind{
            [weak self] isRefreshScreenTag in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
                if isRefreshScreenTag{
                    strongSelf.loadMedications()}
            }
        }
        cartViewModel?.error.bind{
            [weak self] error in
            guard let strongSelf = self else{return}
            DispatchQueue.main.async{
                strongSelf.update(with: error)
            }
        }
    }
    
    @IBAction func changeLanguage(_ sender: UIButton) {
        
        cartViewModel?.changeLanguage()
        
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

  
    
    @IBAction func didReturnBttnTapped(_ sender: UIButton) {
        self.cartViewModel?.didReturnBttnTapped()
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
//        initSearchBar()
        if let lbl = headView.viewWithTag(100) as? UILabel{
            lbl.text = "ShoppingCart"
        }
        headView.searchBar.delegate = self
    }
    
    func collectionViewDidLoad(isScrollToTop:Bool,isShowActivityView:Bool){
            
        showActivityView(isShow: isShowActivityView)
        guard !isShowActivityView else {
            return
        }
          
        medicinesTableView.reloadData()
        medicinesTable_View.isHidden = (cartViewModel?.limit ?? 0) == 0
        totalPriceView.isHidden = (cartViewModel?.limit ?? 0) == 0
        
        if isScrollToTop{
            medicinesTableView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)}
        }
    

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let  height = scrollView.frame.size.height
        let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
        if Int(distanceFromBottom) <= Int(height) { // when you reach the bottom
            cartViewModel?.appendGroupOfMedicines()
        }
//        if contentYoffset == .zero{
//            cartViewModel?.reloadCollection()
//        }
    }
    
    func update(with error: Result_Error) {
        print(error.error_Desc)
    }
    

}
