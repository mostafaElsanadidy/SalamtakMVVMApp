//
//  Observer.swift
//  CheeseBurgerApp
//
//  Created by mostafa elsanadidy on 20.08.22.
//

import Foundation

class Observable<T>{
    var value: T{
        didSet{
            listener.forEach{
                $0(value)
            }
        }
    }
       private var listener:[((T)->Void)] = []
    init(_ value:T) {
        self.value = value
    }
    
    func bind(_ listener:@escaping (T)->Void) {
        listener(value)
        self.listener.append(listener)
    }
}
