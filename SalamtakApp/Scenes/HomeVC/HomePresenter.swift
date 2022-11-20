//
//  Presenter.swift
//  Salamtak
//
//  Created by mostafa elsanadidy on 06.11.22.
//

import Foundation
import UIKit
import MOLH

// object
// need protocol
// ref to interactor, router, view
protocol AnyPresenter {
    func viewDidLoad()
    func saveMedicines()
    func interactorDidAccessCoreData(with result: Result<[Medicine], Result_Error>,state:coreDataStatus)
    func appendGroupOfMedicines()
    var arrOfItemsCount:[Int]{get set}
    var searchKey:String{get set}
    func changeLanguage()
    func updateCellInfo(medicineIndex:Int,collectionCellHandler:((MedicineContainer)->Void)?)
}


protocol AnyMedicationPresenter:AnyPresenter{
    
    var router: AnyMedicationRouter? {get set}
    var interactor: AnyMedicationInteractor? {get set}
    var view: AnyMedicationView? {get set}
    var separateOrdersContainer:SeparateOrdersContainer<Complaint> {get set}
    var defaultHandler:()->() {get set}
    
    func interactorDidFetchMedicines(with result: Result<[Complaint],Result_Error>)
    
    func updateCellSize(medicineIndex:Int,widthForItem:CGFloat,cellSizeHandler:((CGFloat)->Void)?)
    func routeToNextVC()
    
}

struct MedicineContainer {
    var medicineNameText:String = ""
    var medicinePriceText:String = ""
    var medicinePicUrl:URL?
}

struct SeparateOrdersContainer<T>{
    var limit:Int = 0{
        didSet{itemsCountDidSet(limit)}
    }
    var indOfSeparateOrder:Int = 0
    var arrOfSeparateOrders:[T] = []
    var medicines=[T]()
    {
        willSet{
            medicinesWillSet()
        }
        didSet{
            if medicines.count/10 == 0{
                limit = medicines.count
                while indOfSeparateOrder < limit{
                        arrOfSeparateOrders.append(medicines[indOfSeparateOrder])
                           indOfSeparateOrder = indOfSeparateOrder + 1
                       }
            }
            
            if limit < medicines.count{
                limit = arrOfSeparateOrders.count+10
                while indOfSeparateOrder < limit{
                    if indOfSeparateOrder == medicines.count{
                        limit = indOfSeparateOrder
                                break
                            }
                    arrOfSeparateOrders.append(medicines[indOfSeparateOrder])
                    indOfSeparateOrder = indOfSeparateOrder + 1
                               }
                        }
            medicinesDidSet(isScrollToTop, arrOfSeparateOrders)
                    }
    }
    var isScrollToTop = false
    var medicinesDidSet:(Bool,[T])->Void = {_,_  in}
    var medicinesWillSet:()->Void = {}
    var itemsCountDidSet:(Int)->Void = {_ in }
}

enum coreDataStatus{
    case create
    case read
    case update
    case delete
    case search
}


class MedicationPresenter: AnyMedicationPresenter {
    
    
    var router: AnyMedicationRouter?
    
    var interactor: AnyMedicationInteractor?
    
    var separateOrdersContainer = SeparateOrdersContainer<Complaint>()
    var medicineContainer = MedicineContainer()
    var medicines:[Complaint] = []
    var view: AnyMedicationView?
    
    var indexFrom = 0
    var indexTo = 10
    var searchKey = ""{
        didSet{
            
            if searchKey != oldValue{
                indexFrom = 0
                indexTo = 10
                self.separateOrdersContainer.limit = 0
                self.separateOrdersContainer.indOfSeparateOrder = 0
                self.separateOrdersContainer.medicines = []
                self.separateOrdersContainer.arrOfSeparateOrders = []
            }
        }
    }
    
    var indeces:[Int] = []
    var isWantToUpdate:Bool = false
    var selectedIndex:Int = 0
    var totalPrice:Float = 0
    
    
    var arrOfItemsCount:[Int] = [] {
        didSet{
            let counts = arrOfItemsCount
            let items = medicines
            let prices = counts.enumerated()
    //                .filter{ (tuple.oldValues.count != 0 && abs(tuple.oldValues[$0.offset]-$0.element) != 0)}
                .filter{$0.element != 0}
                .map{(index, element) -> Float in
                    let medicine = items[index]
                    return Float(element) * (medicine.price ?? 0.0)
                }
            self.totalPrice = prices.reduce(0,+)
            self.view?.updateCountOfSelectedItems(numOfItems: counts.reduce(0,+), totalPrice: strDidShortenPrice(price: totalPrice))
        }
    }
    
    
    //MARK: - DEFAULT HANDLER
    var defaultHandler: ()->() = {}
    func viewDidLoad() {
        self.separateOrdersContainer.medicinesDidSet = { isScrollToTop,medicines in
            self.medicines = medicines
            self.view?.collectionViewDidLoad(isScrollToTop: isScrollToTop)
        }
        self.separateOrdersContainer.medicinesWillSet = self.view?.collectionViewWillLoad ?? {}
        
        self.separateOrdersContainer.itemsCountDidSet =
        {
            limit in
            
            if limit > self.arrOfItemsCount.count{
                self.arrOfItemsCount.append(contentsOf: Array.init(repeating: 0, count: limit-self.arrOfItemsCount.count))
                }
        }
        
        
        appendGroupOfMedicines()
        
        view?.loadMedications()
        
        
    }
    func routeToNextVC() {
        router?.route(to: CartRouter.start())
    }
    func appendGroupOfMedicines() {
        interactor?.getMedicines(indexFrom: "\(indexFrom)", IndexTo: "\(indexTo)", searchKey: searchKey)
    }
    func changeLanguage() {
        MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
        
        MOLH.reset()
    }
    
}

extension MedicationPresenter{
    
    func interactorDidFetchMedicines(with result: Result<[Complaint], Result_Error>) {
        switch result {
        case .failure(let error):
            self.view?.update(with: error)
        case .success(let medicines_data):
            self.update(with: medicines_data)
        }
    }
    
    func update(with medicines: [Complaint]) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
            let numOfItemsPerAppending = 10
            if medicines.count > numOfItemsPerAppending{
                for index in 0..<numOfItemsPerAppending{
                    self.separateOrdersContainer.medicines.append(medicines[index])
                }
            }else{
                self.separateOrdersContainer.medicines.append(contentsOf: medicines)}
            self.indexFrom += 10
            self.indexTo += 10
            
            self.interactor?.loadMedicines()
        }
        
    }
}

extension MedicationPresenter{
    
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
        self.medicineContainer.medicineNameText = "lang".localized == "en" ? (medicine.englishName ?? "") : (medicine.arabicName ?? "")
        
        self.medicineContainer.medicinePriceText = strDidShortenPrice(price: medicine.price)
        return medicine
    }
    
    
    //CustomLayoutDelegate method
    func heightFor(using width: CGFloat) -> CGFloat {
        //Implement your own logic to return the height for specific cell
        let medicineTitleHeight = self.medicineContainer.medicineNameText.sizeOfString(constrainedToWidth: width, font: UIFont.systemFont(ofSize: 19, weight: .regular)).height
        let medicineSourceTextHeight = self.medicineContainer.medicinePriceText.sizeOfString(constrainedToWidth: width, font: UIFont.systemFont(ofSize: 17, weight: .bold)).height
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

extension MedicationPresenter{
    
    
    
    //     //MARK: - the C in the word CRUD
        func saveMedicines(){
            let indeces = self.arrOfItemsCount.enumerated()
//                    .filter{(_, element) in element != 0}
                    .map{$0.offset}
            
            indeces.forEach{
                index in
                selectedIndex = index
                isWantToUpdate = true
                searchMedicines(with: ("enName",separateOrdersContainer.arrOfSeparateOrders[index].englishName))
            }
        }
//    //    //MARK: - the R in the word CRUD
        func searchMedicines(with searchTuple:(key:String,text:String)){

            interactor?.searchMedicines(with: searchTuple)
        }
//    //
//        func loadMedicines(){
//            interactor?.loadMedicines(parentRestaurant: restaurantTuple)
//        }
//        func loadMedicines(parentRestaurant restaurantTuple:(key:String,name:String)?) {
//            interactor?.loadMedicines(parentRestaurant: restaurantTuple)
//        }
//    //
//    //
//        //MARK: - the U in the word CRUD
    func updateMedicine(at index:Int,with quantity:Int){

            interactor?.updateMedicine(at: index, with: quantity)

        }
//    //    //MARK: - the D in the word CRUD
//
//        func deleteItems(at index: Int) {
//            interactor?.deleteItems(at: index)
//        }
    
}

extension MedicationPresenter{
    
    func interactorDidAccessCoreData(with result: Result<[Medicine], Result_Error>, state: coreDataStatus) {
        switch result {
        case .failure(let error):
            self.view?.update(with: error)
        case .success(let medicines_data):
        let medicines = medicines_data
        switch state {
        case .search:
            if isWantToUpdate{
 
                let count = self.arrOfItemsCount[selectedIndex]
                if medicines.count == 0 {
                    // here you are inserting
                    if count != 0{
                        interactor?.saveMedicines(medicine: separateOrdersContainer.arrOfSeparateOrders[selectedIndex],quantity:count)}
                 } else {
                    // here you are updating
                     if count != 0{
                         updateMedicine(at: selectedIndex, with: count)}
                     else{
                         interactor?.deleteMedicines(where: separateOrdersContainer.arrOfSeparateOrders[selectedIndex].englishName ?? "")
                     }
                 }
            }
        default:
            let _ = medicines.map{print(
                "lang".localized == "en" ? $0.enName ?? "" : $0.arName ?? ""
                )}
        }
        
            
                medicines.forEach{
                    element in
                    if let index = self.separateOrdersContainer.medicines.firstIndex(where:{  $0.englishName==element.enName}){
                        self.arrOfItemsCount[index] = Int(element.quantity)
                    }
                    
                }
        view?.collectionViewDidLoad(isScrollToTop: false)
    }
        
    }
    
}

