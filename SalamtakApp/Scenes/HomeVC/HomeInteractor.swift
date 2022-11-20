//
//  Interactor.swift
//  Salamtak
//
//  Created by mostafa elsanadidy on 06.11.22.
//

import Foundation

// object
// need protocol
// ref to presenter


protocol AnyInteractor{
    
    func deleteMedicines(where itemName: String)
    func searchMedicines(with searchTuple:(key:String,text:String))
    func loadMedicines()
    func updateMedicine(at index:Int,with newQuantity:Int)
}

protocol AnyMedicationInteractor:AnyInteractor {

    var presenter: AnyMedicationPresenter?{get set}
    func getMedicines(indexFrom:String,IndexTo:String,searchKey:String)
    func saveMedicines(medicine:Complaint,quantity:Int)
}

class MedicationInteractor: AnyMedicationInteractor{
    
    
    var defaultHandler: ()->() = {}
    var presenter: AnyMedicationPresenter?
    var managedObjectHandler:ManagedObjectHandler?

    
    init() {
        managedObjectHandler = ManagedObjectHandler()
    }
    
    func getMedicines(indexFrom: String, IndexTo: String, searchKey: String) {
        APIClient.searchForRecipe(indexFrom: indexFrom, indexTo: IndexTo, serchKey: searchKey){[unowned self] (result) in
            switch result {
            case .failure(let error) :
                self.presenter?.interactorDidFetchMedicines(with: .failure(error))
            case .success(let value) :
                guard let medicines_data = value else { return  }
                self.presenter?.interactorDidFetchMedicines(with: .success(medicines_data))
            }
        }
    }
    
    
    // MARK: - Get My Recipes Data
    func getStringFromArr(strArr:[String],separator:String) -> String
      {
          var dataStr = ""
        
          for (key,value) in strArr.enumerated()
          {
              dataStr += "\(value)"
              if key < strArr.count-1 {
                  dataStr += separator
              }
          }
          return dataStr
      }
    
    
    //MARK: - the R in the word CRUD
    
    
    //MARK: - the U in the word CRUD
}

extension MedicationInteractor{
    
    
    typealias ManagedObjectHandler = CoreDataHandler<Medicine>
    
    func saveMedicines(medicine:Complaint,quantity:Int) {
        let selectedMedicine = Medicine.init(context: viewContext)
                    let medicine = medicine
                    selectedMedicine.enName = medicine.englishName
                    selectedMedicine.arName = medicine.arabicName
                    selectedMedicine.price = medicine.price
                    selectedMedicine.picUrl = medicine.picUrl
                    selectedMedicine.quantity = Int16(quantity)
        managedObjectHandler?.saveItems(afterSaving: {
            [unowned self]
            result in
            switch result {
            case .failure(let error) :
                self.presenter?.interactorDidAccessCoreData(with: .failure(error),state: .create)
            case .success(let value) :
                guard let medicines_data = value else { return  }
                self.presenter?.interactorDidAccessCoreData(with: .success(medicines_data), state: .create)

            }
        })
    }

    func deleteMedicines(where itemName: String) {
        let index = managedObjectHandler?.items.firstIndex(where: { $0.enName == itemName })
          managedObjectHandler?.deleteItems(at:
                                                index ?? 0
                                                , afterDelete: {
              [unowned self]
              result in
              switch result {
              case .failure(let error) :
                  self.presenter?.interactorDidAccessCoreData(with: .failure(error),state: .delete)
              case .success(let value) :
                  guard let medicines_data = value else { return  }
                  self.presenter?.interactorDidAccessCoreData(with: .success(medicines_data), state: .delete)

              }
          })
      }

    func searchMedicines(with searchTuple: (key: String, text: String)) {
        managedObjectHandler?.searchForItem(with: searchTuple, initialRequest: Medicine.fetchRequest(), didEndSearching: {
            [unowned self]
            result in
            switch result {
            case .failure(let error) :
                self.presenter?.interactorDidAccessCoreData(with: .failure(error),state: .search)
            case .success(let value) :
                guard let medicines_data = value else { return  }
                self.presenter?.interactorDidAccessCoreData(with: .success(medicines_data), state: .search)

            }
        })
    }

    func loadMedicines() {

        managedObjectHandler?.loadItems(with: Medicine.fetchRequest()){
            [unowned self]
            result in
            switch result {
            case .failure(let error) :
                self.presenter?.interactorDidAccessCoreData(with: .failure(error),state: .read)
            case .success(let value) :
                guard let medicines_data = value else { return  }
                self.presenter?.interactorDidAccessCoreData(with: .success(medicines_data), state: .read)

            }
        }
    }

    func updateMedicine(at index:Int,with newQuantity:Int) {
      
        managedObjectHandler?.updateItem(didBeginUpdating: {
            medicines in
            medicines[0].quantity = Int16(newQuantity)
        }, didEndUpdating: {
            [unowned self]
            result in
            
            switch result {
            case .failure(let error) :
                self.presenter?.interactorDidAccessCoreData(with: .failure(error),state: .update)
            case .success(let value) :
                guard let medicines_data = value else { return  }
                self.presenter?.interactorDidAccessCoreData(with: .success(medicines_data), state: .update)

            }
        })
    }

}
