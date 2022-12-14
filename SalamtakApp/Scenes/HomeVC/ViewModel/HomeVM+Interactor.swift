//
//  HomeVM+Interactor.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 19.11.22.
//

import Foundation

// object
// need protocol
// ref to ViewModel




extension MedicationViewModel{
    
    
    // MARK: - Get My Medicines Data
    func getMedicines(indexFrom: String, IndexTo: String, searchKey: String) {
        APIClient.searchForRecipe(indexFrom: indexFrom, indexTo: IndexTo, serchKey: searchKey){[unowned self] (result) in
            switch result {
            case .failure(let error) :
                self.interactorDidFetchMedicines(with: .failure(error))
            case .success(let value) :
                guard let medicines_data = value else { return  }
                self.interactorDidFetchMedicines(with: .success(medicines_data))
            }
        }
    }
    
}

extension MedicationViewModel{
    
    
    typealias ManagedObjectHandler = CoreDataHandler<Medicine>
    
    //MARK: - the C in the word CRUD
    
    func saveMedicines(medicine:Complaint,quantity:Int) {
        let selectedMedicine = Medicine.init(context: viewContext)
                    let medicine = medicine
                    selectedMedicine.enName = medicine.englishName
                    selectedMedicine.arName = medicine.arabicName
                    selectedMedicine.price = medicine.price
                    selectedMedicine.picUrl = medicine.picUrl
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

   

    //MARK: - the R in the word CRUD
    
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

    //MARK: - the U in the word CRUD
    
    func updateMedicine(at index:Int,with newQuantity:Int) {
      
        managedObjectHandler?.updateItem(didBeginUpdating: {
            medicines in
            medicines[0].quantity = Int16(newQuantity)
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

    //MARK: - the D in the word CRUD
    
    func deleteMedicines(where itemName: String) {
        let index = managedObjectHandler?.items.firstIndex(where: { $0.enName == itemName })
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
    
}
