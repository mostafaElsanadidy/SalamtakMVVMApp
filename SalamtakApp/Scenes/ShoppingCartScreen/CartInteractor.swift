//
//  CartInteractor.swift
//  Salamtak_App
//
//  Created by mostafa elsanadidy on 09.11.22.
//

import Foundation
import CoreData

protocol AnyCartInteractor:AnyInteractor{
    var presenter: AnyCartPresenter?{get set}
    func saveMedicines(medicine:Medicine,quantity:Int)
}
class CartInteractor:AnyCartInteractor {
    
    typealias ManagedObjectHandler = CoreDataHandler<Medicine>
    var presenter: AnyCartPresenter?
    var managedObjectHandler:ManagedObjectHandler?
    
    
    init() {
        managedObjectHandler = ManagedObjectHandler()
    }
    
    
    func saveMedicines(medicine:Medicine,quantity:Int) {
    
        let selectedMedicine = Medicine.init(context: viewContext)
                    let medicine = medicine
                    selectedMedicine.enName = medicine.enName
                    selectedMedicine.arName = medicine.arName
                    selectedMedicine.price = medicine.price
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
        let index = managedObjectHandler?.items.firstIndex(where: {
//            "lang".localized == "en" ? ($0.enName == itemName) : ($0.arName == itemName)
            ($0.enName == itemName)
            })
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
