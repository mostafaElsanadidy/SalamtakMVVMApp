////
////  SearchVC+CoreDataProcesses(CRUD).swift
////  RecipesApp
////
////  Created by mostafa elsanadidy on 25.06.22.
////
//
import Foundation
import CoreData
import UIKit
//
protocol AnyCoreDataHandler {
  //  var defaultHandler:()->(){get set}
   // var items:[T]{get set}
    associatedtype U
    associatedtype T
    func saveItems(afterSaving executionHandler:(Result<[T]? , Result_Error>) -> Void)
    func searchForItem(with searchTuple:(key:String,text:String), parent parentItem:(key:String,name:String)?, initialRequest: U,didEndSearching handler:@escaping (Result<[T]? , Result_Error>) -> Void)
    func loadItems(with request: U, parent parentItem:(key:String,name:String)?, didEndLoading handler:(Result<[T]? , Result_Error>) -> Void)
    func updateItem(didBeginUpdating updateHandler:([T])->(), didEndUpdating afterUpdateHandler: (Result<[T]? , Result_Error>) -> Void)
    func deleteItems(at index:Int,afterDelete executionHandler: (Result<[T]? , Result_Error>) -> Void)
}
//
class CoreDataHandler<T:NSManagedObject>:AnyCoreDataHandler {
    
    var defaultHandler: () -> () = {}
    
    var items: [T] = []
    
    typealias U = NSFetchRequest<T>
   
    //MARK: - DEFAULT HANDLER
//    var defaultHandler: ()->() {
//        get {
//            return self.defaultHandler
//        }
//        set {
//            self.defaultHandler = newValue
//        }
//    }
    
   
    //MARK: - the D in the word CRUD
    func deleteItems(at index:Int,afterDelete executionHandler:(Result<[T]? , Result_Error>) -> Void) {
        viewContext.delete(items[index])
        items.remove(at: index)
        saveItems(afterSaving: executionHandler)
    }
    
    //MARK: - the C in the word CRUD
    func saveItems(afterSaving executionHandler:(Result<[T]? , Result_Error>) -> Void){
        do {
            try viewContext.save()
            executionHandler(.success(items))
        } catch {
//            print("Error Savinng Context".localized+"\(error)")
            executionHandler(.failure(.status_Failure))
        }
    }
    
    //MARK: - the R in the word CRUD
    func searchForItem(with searchTuple:(key:String,text:String), parent parentItem:(key:String,name:String)?=nil, initialRequest:NSFetchRequest<T>, didEndSearching handler: @escaping (Result<[T]? , Result_Error>) -> Void){
        
         let request:NSFetchRequest<T> = initialRequest
        
        let predicate = NSPredicate.init(format: "\(searchTuple.key) CONTAINS[cd] %@",searchTuple.text)
        if parentItem == nil{
            request.predicate = predicate
        }else{
            let parentRestaurantPredicate = NSPredicate(format: "\(parentItem?.key ?? "") MATCHES %@",parentItem?.name ?? "")
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate,parentRestaurantPredicate])
        }
       
        
        request.sortDescriptors = [NSSortDescriptor(key: "\(searchTuple.key)", ascending: true)]
//        print(request)
        loadItems(with: request, parent: nil, didEndLoading: handler)
    }
    
    func loadItems(with request: NSFetchRequest<T>, parent parentItem:(key:String,name:String)?=nil, didEndLoading handler: (Result<[T]? , Result_Error>) -> Void ) {
        do {
        
            if parentItem == nil{
              
            }else{
                let parentRestaurantPredicate = NSPredicate(format: "\(parentItem?.key ?? "") MATCHES %@",parentItem?.name ?? "")
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentRestaurantPredicate])
            }

//            print(request)
            items = try viewContext.fetch(request)
            handler(.success(items))
        }
        catch {
//            print("Error Loading Data From Context".localized + "\(error)")
            handler(.failure(.status_Failure))
        }
    }
    
    //MARK: - the U in the word CRUD
    func updateItem(didBeginUpdating updateHandler:([T])->(), didEndUpdating afterUpdateHandler:(Result<[T]? , Result_Error>) -> Void) {
       
        updateHandler(items)
       
        saveItems(afterSaving: afterUpdateHandler)
    }
}
