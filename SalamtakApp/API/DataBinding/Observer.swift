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
    
    //we create a function that allows other View controller to be able to listen to or subscribe to any changes in data
    //parameter (listener: @escaping (T?)->Void) in func bind : is like as sending data using closure .. the caller of listener:(T?)->Void is the object which send data/values (in shape of notification and put it in parameter T in listener:(T?)->Void) and the code of closure put in the object(view controller) which listen to this notification
    func bind(_ listener:@escaping (T)->Void) {
        listener(value)
        self.listener.append(listener)
    }
}
