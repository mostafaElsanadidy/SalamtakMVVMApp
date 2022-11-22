//
//  Pagination.swift
//  SalamtakApp
//
//  Created by mostafa elsanadidy on 21.11.22.
//

import Foundation

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
