//
//  Interactor.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 21.11.22.
//

import Foundation
protocol AnyInteractor{
    func updateMedicine(at index:Int,with newQuantity:Int)
    func saveMedicines()
}

