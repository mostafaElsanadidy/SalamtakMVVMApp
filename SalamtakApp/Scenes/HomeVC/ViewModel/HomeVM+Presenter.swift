//
//  ViewModel.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 19.11.22.
//

import Foundation
import UIKit
import MOLH

enum coreDataStatus{
    case create
    case read
    case update
    case delete
    case search
}



class MedicationViewModel: AnyMedicationViewModel {
   
    var coordinator: MainCoordinator?
    
    //MARK: - properties of Data Binding
    
    var error: Observable<Result_Error> = Observable(.status_Failure)
    
    var isRefreshScreenTag: Observable<Bool> = Observable(false)
  
    var tupleOf_totalPrice_arrOfItemsCount: Observable<(totalPriceText: String, arrOfItemsCount: [Int])> = Observable((totalPriceText:"",arrOfItemsCount:[]))
    
    var tupleOf_isScrollTag_isShowActivityView: Observable<(isScrollToTop:Bool,isShowActivityView:Bool)> = Observable((isScrollToTop:false,isShowActivityView:false))
       
    var accessCoreDataSuccessState: Observable<coreDataStatus> = Observable(.read)
    
    
    //MARK: - properties of Pagination
    var indexFrom = 0
    var indexTo = 10
    var separateOrdersContainer = SeparateOrdersContainer<Complaint>()
    var medicineContainer = MedicineContainer()
    var medicines : [Complaint] = []
    var limit: Int = 0
    
    var searchKey = ""{
        didSet{
            
            if searchKey != oldValue{
                reloadCollection()
            }
        }
    }
    
    //MARK: - properties of CoreDataHandler
    var managedObjectHandler:ManagedObjectHandler?

    
    init() {
        managedObjectHandler = ManagedObjectHandler()
    }
    
    
    var isWantToUpdate:Bool = false
    var selectedIndex:Int = 0
    var totalPrice:Float = 0
    var original_arrOfItemsCount:[Int]?
    var arrOfItemsCount:[Int] = []{
        didSet{
            let counts = arrOfItemsCount
            let items = medicines
            let prices = counts.enumerated()
                .filter{$0.element != 0}
                .map{(index, element) -> Float in
                    let medicine = items[index]
                    return Float(element) * (medicine.price ?? 0.0)
                }
            totalPrice = prices.reduce(0,+)
            tupleOf_totalPrice_arrOfItemsCount.value = (totalPriceText:strDidShortenPrice(price: totalPrice),arrOfItemsCount:counts)
        }
    }
    
    //MARK: - viewDidLoad
    
    func viewDidLoad() {
        separateOrdersContainer.medicinesDidSet = {
            [weak self]
            isScrollToTop,medicines in
            guard let strongSelf = self else{return}
            strongSelf.medicines = medicines
            strongSelf.tupleOf_isScrollTag_isShowActivityView.value = (isScrollToTop:isScrollToTop,isShowActivityView:false)
        }
        separateOrdersContainer.itemsCountDidSet =
        {
            [weak self]
            limit in
            guard let strongSelf = self else{return}
            strongSelf.limit = limit
            if limit > strongSelf.arrOfItemsCount.count{
                strongSelf.arrOfItemsCount.append(contentsOf: Array.init(repeating: 0, count: limit-strongSelf.arrOfItemsCount.count))
                }
        }
        
//        appendGroupOfMedicines()
        
        isRefreshScreenTag.value = true
    }
    
    func viewWillAppear() {
        reloadCollection()
    }
    
    func routeToNextVC() {
        coordinator?.childShowCartItems()
    }
    
    func appendGroupOfMedicines() {
        tupleOf_isScrollTag_isShowActivityView.value = (isScrollToTop:true,isShowActivityView:true)
        getMedicines(indexFrom: "\(indexFrom)", IndexTo: "\(indexTo)", searchKey: searchKey)
    }
    
    func reloadCollection(){
        indexFrom = 0
        indexTo = 10
        separateOrdersContainer.limit = 0
        separateOrdersContainer.indOfSeparateOrder = 0
        separateOrdersContainer.medicines = []
        separateOrdersContainer.arrOfSeparateOrders = []
        appendGroupOfMedicines()
    }
    
    func changeLanguage() {
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        
        MOLH.reset()
    }
    
}

extension MedicationViewModel{
    
    func interactorDidFetchMedicines(with result: Result<[Complaint], Result_Error>) {
        switch result {
        case .failure(let error):
            self.error.value = error
        case .success(let medicines_data):
            update(with: medicines_data)
        }
    }
    
    func update(with medicines: [Complaint]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            [weak self]  in
            guard let strongSelf = self else{return}
            let numOfItemsPerAppending = 10
            if medicines.count > numOfItemsPerAppending{
                for index in 0..<numOfItemsPerAppending{
                    strongSelf.separateOrdersContainer.medicines.append(medicines[index])
                }
            }else{
                strongSelf.separateOrdersContainer.medicines.append(contentsOf: medicines)}
            strongSelf.indexFrom += 10
            strongSelf.indexTo += 10
            strongSelf.readMedicines()
        }
        
    }
}


extension MedicationViewModel{
    
    func updateCellInfo(medicineIndex:Int,collectionCellHandler:((MedicineContainer)->Void)?){
         let medicine = getFromApiData(medicineIndex: medicineIndex)
        let originalUrl = (medicine.picUrl ?? "")
        let updatedUrl = originalUrl.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
         let sp_url = URL(string: updatedUrl ?? "")
        medicineContainer.medicinePicUrl = sp_url
        collectionCellHandler?(medicineContainer)
    }
    
    func updateCellSize(medicineIndex:Int,widthForItem:CGFloat,cellSizeHandler:((CGFloat)->Void)?){
        let _ = getFromApiData(medicineIndex: medicineIndex)
        cellSizeHandler?(heightFor(using: widthForItem-200))
    }
    
    func getFromApiData(medicineIndex:Int)->Complaint{
        let medicine = separateOrdersContainer.arrOfSeparateOrders[medicineIndex]
        medicineContainer.medicineNameText = "lang".localized == "en" ? (medicine.englishName ?? "") : (medicine.arabicName ?? "")
        
        medicineContainer.medicinePriceText = strDidShortenPrice(price: medicine.price)
        return medicine
    }
    
    
    //CustomLayoutDelegate method
    func heightFor(using width: CGFloat) -> CGFloat {
        //Implement your own logic to return the height for specific cell
        let medicineTitleHeight = medicineContainer.medicineNameText.sizeOfString(constrainedToWidth: width, font: UIFont.systemFont(ofSize: 19, weight: .regular)).height
        let medicineSourceTextHeight = medicineContainer.medicinePriceText.sizeOfString(constrainedToWidth: width, font: UIFont.systemFont(ofSize: 17, weight: .bold)).height
        let height = medicineTitleHeight+medicineSourceTextHeight+100
        return height
    }
    
    func strDidShortenPrice(price:Float?) -> String{
        let fullPrice = "\(price ?? 0)"
        let fullPriceArr = fullPrice.split{$0 == "."}.map(String.init)
        let updatedPriceStr = (fullPriceArr.count > 1 && fullPriceArr[1] == "0" ? fullPriceArr[0] : fullPrice).localized+" "+"pounds".localized
        return updatedPriceStr
    }
}

extension MedicationViewModel{
    
    
    
    //     //MARK: - Before the C in the word CRUD
        func saveMedicines(){
           
            _ = arrOfItemsCount.enumerated().map{$0.offset}
            arrOfItemsCount.enumerated().map{$0.offset}.forEach{
                index in
                guard arrOfItemsCount[index] != original_arrOfItemsCount?[index] || original_arrOfItemsCount == nil else{return}
                selectedIndex = index
                isWantToUpdate = true
                searchMedicines(with:
                                    ("enName",separateOrdersContainer.arrOfSeparateOrders[index].englishName))
            }
        }
}

extension MedicationViewModel{
    
    func interactorDidAccessCoreData(with result: Result<[Medicine], Result_Error>, state: coreDataStatus) {
        switch result {
        case .failure(let error):
            self.error.value = error
        case .success(let medicines_data):
        let medicines = medicines_data
        switch state {
        case .search:
            if isWantToUpdate{
 
                let count = arrOfItemsCount[selectedIndex]
                if medicines.count == 0 {
                    // here you are inserting
                    if count != 0{
                        saveMedicines(medicine: separateOrdersContainer.arrOfSeparateOrders[selectedIndex],quantity:count)}
                 } else {
                    // here you are updating
                     if count != 0{
                         updateMedicine(at: selectedIndex, with: count)}
                     else{
                         deleteMedicines(where: separateOrdersContainer.arrOfSeparateOrders[selectedIndex].englishName ?? "")
                     }
                 }
            }
        case .read:
            original_arrOfItemsCount = arrOfItemsCount
        arrOfItemsCount.enumerated().forEach{
            itemCount in
            let indecies = medicines.enumerated().filter{$0.element.enName == separateOrdersContainer.medicines[itemCount.offset].englishName}.map{$0.offset}
            if indecies.count > 0
                {
                arrOfItemsCount[itemCount.offset] = Int(medicines[indecies[0]].quantity)
                original_arrOfItemsCount?[itemCount.offset] = arrOfItemsCount[itemCount.offset]
            }else{
                if itemCount.element > 0{
                    arrOfItemsCount[itemCount.offset] = 0
                    original_arrOfItemsCount?[itemCount.offset] = arrOfItemsCount[itemCount.offset]
                }
            }}
        case .create:
            self.accessCoreDataSuccessState.value = .create
        case .update:
            self.accessCoreDataSuccessState.value = .update
        default:
            let _ = medicines.map{print(
                "lang".localized == "en" ? $0.enName ?? "" : $0.arName ?? ""
                )}
        }
    }
        
    }
    
}


