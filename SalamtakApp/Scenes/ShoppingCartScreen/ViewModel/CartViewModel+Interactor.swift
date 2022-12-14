//
//  CartViewModel+Interactor.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 20.11.22.
//

import Foundation
import CoreData

extension CartViewModel{
    
   
    
    
    func saveMedicines(medicine:Medicine,quantity:Int) {
    
        let selectedMedicine = Medicine.init(context: viewContext)
                    let medicine = medicine
                    selectedMedicine.enName = medicine.enName
                    selectedMedicine.arName = medicine.arName
                    selectedMedicine.price = medicine.price
                    selectedMedicine.quantity = Int16(quantity)
                    selectedMedicine.createdDate = Date()
        managedObjectHandler?.saveItems(afterSaving: {
            [unowned self]
            result in
            switch result {
            case .failure(let error) :
                self.interactorDidAccessCoreData(with: .failure(error),state: .create)
            case .success(let value) :
                guard let medicines_data = value else { return  }
                self.interactorDidAccessCoreData(with: .success(medicines_data), state: .create)

            }
            
        })
    }

    func deleteMedicines(where itemName: String) {
        let index = managedObjectHandler?.items.firstIndex(where: {
            "lang".localized == "en" ? ($0.enName == itemName) : ($0.arName == itemName)
            })
          managedObjectHandler?.deleteItems(at:
                                                index ?? 0
                                                , afterDelete: {
              [unowned self]
              result in
              switch result {
              case .failure(let error) :
                  self.interactorDidAccessCoreData(with: .failure(error),state: .delete)
              case .success(let value) :
                  guard let medicines_data = value else { return  }
                  self.interactorDidAccessCoreData(with: .success(medicines_data), state: .delete)

              }
          })
      }

    func searchMedicines(with searchTuple: (key: String, text: String)) {
        managedObjectHandler?.searchForItem(with: searchTuple, initialRequest: Medicine.fetchRequest(), didEndSearching: {
            [unowned self]
            result in
            switch result {
            case .failure(let error) :
                self.interactorDidAccessCoreData(with: .failure(error),state: .search)
            case .success(let value) :
                guard let medicines_data = value else { return  }
                self.interactorDidAccessCoreData(with: .success(medicines_data), state: .search)

            }
        })
    }

    func readMedicines() {

        managedObjectHandler?.loadItems(with: Medicine.fetchRequest()){
            [unowned self]
            result in
            switch result {
            case .failure(let error) :
                self.interactorDidAccessCoreData(with: .failure(error),state: .read)
            case .success(let value) :
                guard let medicines_data = value else { return  }
                let nowDate = Date()
                let threeDaysAgoDate = Calendar.current.date(byAdding: .day , value: -3, to: nowDate)!
                let toBeRemovedMedicines = medicines_data.filter { !($0.createdDate ?? Date() <= threeDaysAgoDate) }
                if toBeRemovedMedicines.count < medicines_data.count{
                    managedObjectHandler?.removeMedicinesOlderThan(days: 3)
                }
                self.interactorDidAccessCoreData(with: .success(toBeRemovedMedicines), state: .read)

            }
        }
    }

    func updateMedicine(at index:Int,with newQuantity:Int) {
        managedObjectHandler?.updateItem(didBeginUpdating: {
            medicines in
            medicines[index].quantity = Int16(newQuantity)
        }, didEndUpdating: {
            [unowned self]
            result in
            switch result {
            case .failure(let error) :
                self.interactorDidAccessCoreData(with: .failure(error),state: .update)
            case .success(let value) :
                guard let medicines_data = value else { return  }
                self.interactorDidAccessCoreData(with: .success(medicines_data), state: .update)

            }
        })
    }

}
