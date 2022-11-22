//
//  CartViewModel+Presenter.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 20.11.22.
//

import Foundation
import CoreData
import MOLH

class CartViewModel: AnyCartViewModel{
    
      var coordinator: ShoppingCatCoordinator?
    
    //MARK: - properties of Data Binding
    
    var accessCoreDataSuccessState: Observable<coreDataStatus> = Observable(.read)
    
    var error: Observable<Result_Error> = Observable(.status_Failure)
    
    var isRefreshScreenTag: Observable<Bool> = Observable(false)
  
    var tupleOf_totalPrice_arrOfItemsCount: Observable<(totalPriceText: String, arrOfItemsCount: [Int])> = Observable((totalPriceText:"",arrOfItemsCount:[]))
    
    var tupleOf_isScrollTag_isShowActivityView: Observable<(isScrollToTop:Bool,isShowActivityView:Bool)> = Observable((isScrollToTop:false,isShowActivityView:false))
    
    //MARK: - properties of Pagination
    
    var limit: Int = 0{
        didSet{
            self.tupleOf_isScrollTag_isShowActivityView.value = (isScrollToTop:false,isShowActivityView:false)
        }
    }
    
    var medicines : [Medicine] = []{
        didSet{
            medicines = medicines.sorted{
                return ("lang".localized == "en") ? (($0.enName ?? "")<($1.enName ?? "")) : (($0.arName ?? "")<($1.arName ?? ""))
                }
            self.arrOfItemsCount = medicines.map{Int($0.quantity)}
        }
    }
    var arrOfItemsCount:[Int] = []{
        didSet{
            itemsCountDidSet(tuple: (items:medicines,counts:arrOfItemsCount))
        }
    }
    
    var medicineContainer = MedicineContainer()
    var separateOrdersContainer = SeparateOrdersContainer<Medicine>()
    {
        didSet{
            updateMedicines_Data(limit: separateOrdersContainer.limit)
        }
}
    var searchKey: String = ""{
        didSet{
            if searchKey != oldValue{
                reloadCollection()
            }}
    }
    
    //MARK: - properties of CoreDataHandler
    typealias ManagedObjectHandler = CoreDataHandler<Medicine>
    var managedObjectHandler:ManagedObjectHandler?
    
    
    init() {
        managedObjectHandler = ManagedObjectHandler()
    }
    var isWantToUpdate:Bool = false
    
    var selectedIndex:Int = 0
    var totalPrice:Float = 0
   
    //MARK: - viewDidLoad
    
    func viewDidLoad() {
        
        self.separateOrdersContainer.medicinesDidSet = { isScrollToTop,medicines in
            self.medicines = medicines
            self.tupleOf_isScrollTag_isShowActivityView.value = (isScrollToTop:isScrollToTop,isShowActivityView:false)
        }
                self.separateOrdersContainer.itemsCountDidSet = {_ in}
                
                self.isRefreshScreenTag.value = true
    }
    
    func viewWillAppear() {
        readMedicines()
    }
    
    func reloadCollection() {
        if searchKey != ""{
            let key = "lang".localized == "en" ? "enName" : "arName"
            self.searchMedicines(with: (key:key,text:searchKey))
        }
            else{
                self.readMedicines()
            }
    }
    
    func didReturnBttnTapped() {
//        router?.stop()
    }
    
    
    func changeLanguage() {
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        MOLH.reset()
    }
    
    func strDidShortenPrice(price:Float?) -> String{
        let fullPrice = "\(price ?? 0)"
        let fullPriceArr = fullPrice.split{$0 == "."}.map(String.init)
        let updatedPriceStr = (fullPriceArr.count > 1 && fullPriceArr[1] == "0" ? fullPriceArr[0] : fullPrice).localized+" "+"pounds".localized
        return updatedPriceStr
    }
}

extension CartViewModel{
    
    //     //MARK: - the C in the word CRUD
        func saveMedicines(){
            let indeces = self.arrOfItemsCount.enumerated()
//                    .filter{(_, element) in element != 0}
                    .map{$0.offset}
            
            indeces.forEach{
                index in
                selectedIndex = index
                isWantToUpdate = true
                searchMedicines(with: ("name",separateOrdersContainer.arrOfSeparateOrders[index].enName ?? ""))
            }
        }
    
//    //    //MARK: - the R in the word CRUD

//        //MARK: - the U in the word CRUD

//    //    //MARK: - the D in the word CRUD
//
        func deleteItems(at index: Int) {
            
            self.arrOfItemsCount[index] = 0
            self.deleteMedicines(where: self.medicines[index].enName ?? "")
            _ = self.arrOfItemsCount.remove(at: index)
        }
    
    
    func interactorDidAccessCoreData(with result: Result<[Medicine], Result_Error>, state: coreDataStatus) {
        switch result {
        case .failure(let error):
            self.error.value = error
        case .success(let medicines_data):
        let medicines = medicines_data
        switch state {
        case .search:
            if isWantToUpdate{
                
                let count = self.arrOfItemsCount[selectedIndex]
                if medicines.count == 0 {
                    // here you are inserting
                    if count != 0{
                        self.saveMedicines(medicine: separateOrdersContainer.arrOfSeparateOrders[selectedIndex],quantity:count)}
                 } else {
                    // here you are updating
                     if count != 0{
                         updateMedicine(at: selectedIndex, with: count)}
                     else{
                         
                         self.deleteMedicines(where: separateOrdersContainer.arrOfSeparateOrders[selectedIndex].enName ?? "")
                     }
                 }
            }
//        case .read:
//            self.interactorDidFetchMedicines(with: result)
        case .create:
            self.accessCoreDataSuccessState.value = .create
        case .update:
            self.accessCoreDataSuccessState.value = .update
        default:
            let _ = medicines.map{print( "lang".localized == "en" ? ($0.enName ?? "") : ($0.arName ?? "")
                )}
        }
            self.interactorDidFetchMedicines(with: result)
//        view?.collectionViewDidLoad(isScrollToTop: true)
    }
    }
}

extension CartViewModel{
    
    
    func interactorDidFetchMedicines(with result: Result<[Medicine], Result_Error>) {
        switch result {
        case .failure(let error):
            self.error.value = error
        case .success(let recipes_data):
            self.update(with: recipes_data)
        }
    }
    
    func update(with medicines: [Medicine]) {
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            self.separateOrdersContainer.limit = 0
            self.separateOrdersContainer.indOfSeparateOrder = 0
            self.separateOrdersContainer.isScrollToTop = true
            self.separateOrdersContainer.medicines = []
            self.separateOrdersContainer.arrOfSeparateOrders = []
            self.separateOrdersContainer.medicines = medicines
            self.updateMedicines_Data(limit: medicines.count)
        }
    }
    
    
    func updateMedicines_Data(limit:Int){
        self.limit = limit
//        appendGroupOfMedicines()
    }
    func appendGroupOfMedicines() {
        self.separateOrdersContainer.isScrollToTop = false
        self.medicines = {self.medicines}()
    }
    
    func itemsCountDidSet(tuple:(items:[Medicine],counts:[Int])) -> Void {
       
        let prices = tuple.counts.enumerated()
         .filter{$0.element != 0}
            .map{(index, element) -> Float in
                let medicine = tuple.items[index]
                return Float(element) * (medicine.price )
            }
        self.totalPrice = prices.reduce(0,+)
        self.tupleOf_totalPrice_arrOfItemsCount.value = (totalPriceText:strDidShortenPrice(price: totalPrice),arrOfItemsCount:tuple.counts)
    }
    
}

extension CartViewModel{
    func updateCellInfo(medicineIndex:Int,collectionCellHandler:((MedicineContainer)->Void)?){
         
        let medicine = separateOrdersContainer.arrOfSeparateOrders[medicineIndex]
        self.medicineContainer.medicineNameText = "lang".localized == "en" ? (medicine.enName ?? "") : (medicine.arName ?? "")
        self.medicineContainer.medicinePriceText = strDidShortenPrice(price: medicine.price)
        let originalUrl = (medicine.picUrl ?? "")
        let updatedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
         let sp_url = URL(string: updatedUrl ?? "")
        self.medicineContainer.medicinePicUrl = sp_url
        collectionCellHandler?(medicineContainer)
    }
   
    
    
}
