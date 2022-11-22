//
//  Presenter.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 21.11.22.
//

import Foundation
import UIKit

protocol AnyPresenter {
    
    var tupleOf_totalPrice_arrOfItemsCount:Observable<(totalPriceText:String,arrOfItemsCount:[Int])> {get set}
    var tupleOf_isScrollTag_isShowActivityView:Observable<(isScrollToTop:Bool,isShowActivityView:Bool)> {get set}
    var isRefreshScreenTag:Observable<Bool> {get set}
    var error:Observable<Result_Error> {get set}
    var accessCoreDataSuccessState:Observable<coreDataStatus> {get set}
    var arrOfItemsCount:[Int] {get set}
    var limit:Int {get set}
    
    func viewDidLoad()
    func viewWillAppear()
    
    func appendGroupOfMedicines()
    var searchKey:String{get set}
    func changeLanguage()
    func updateCellInfo(medicineIndex:Int,collectionCellHandler:((MedicineContainer)->Void)?)
    func reloadCollection()
}

protocol AnyMedicationViewModel:AnyPresenter,AnyInteractor{
    
    var coordinator : MainCoordinator? {get set}
    func updateCellSize(medicineIndex:Int,widthForItem:CGFloat,cellSizeHandler:((CGFloat)->Void)?)
    func routeToNextVC()
    func saveMedicines(medicine:Complaint,quantity:Int)
    
    
}


protocol AnyCartViewModel:AnyPresenter,AnyInteractor {
    
    var coordinator: ShoppingCatCoordinator? {get set}
    var arrOfItemsCount:[Int] {get set}
    var medicines : [Medicine] {get set}
    var limit:Int{get set}
    var separateOrdersContainer:SeparateOrdersContainer<Medicine> {get set}
    func updateCellInfo(medicineIndex:Int,collectionCellHandler:((MedicineContainer)->Void)?)
    func updateMedicine(at index:Int,with quantity:Int)
    func deleteItems(at index: Int)
    func didReturnBttnTapped()
    func saveMedicines(medicine:Medicine,quantity:Int)
}
