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
    func updateItem(didBeginUpdating updateHandler:([T])->(), didEndUpdating afterUpdateHandler: @escaping (Result<[T]? , Result_Error>) -> Void)
    func deleteItems(at index:Int,afterDelete executionHandler: (Result<[T]? , Result_Error>) -> Void)
}
//
class CoreDataHandler<T:NSManagedObject>:AnyCoreDataHandler {
    
    var defaultHandler: () -> () = {}
    
    var items: [T] = []
    var entityName:String{
        return T.description().components(separatedBy: ".").last! }
    typealias U = NSFetchRequest<T>
   
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

        loadItems(with: request, parent: nil, didEndLoading: handler)
    }
    
    func loadItems(with request: NSFetchRequest<T>, parent parentItem:(key:String,name:String)?=nil, didEndLoading handler: (Result<[T]? , Result_Error>) -> Void ) {
        do {
        
            if parentItem == nil{
              
            }else{
                let parentRestaurantPredicate = NSPredicate(format: "\(parentItem?.key ?? "") MATCHES %@",parentItem?.name ?? "")
                request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentRestaurantPredicate])
            }

            
            items = try viewContext.fetch(request)

            handler(.success(items))
            
        }
        catch {
           
            handler(.failure(.status_Failure))
        }
    }
    
    //MARK: - the U in the word CRUD
    func updateItem(didBeginUpdating updateHandler:([T])->(), didEndUpdating afterUpdateHandler:@escaping (Result<[T]? , Result_Error>) -> Void) {
       
        updateHandler(items)
        DispatchQueue.main.asyncAfter(deadline: .now()+1){
            self.saveItems(afterSaving: afterUpdateHandler)}
    }
    
    func updateAllItemsInOneGo() {
        
        let batchUpdate = NSBatchUpdateRequest(entityName: entityName)
//        batchUpdate.propertiesToUpdate = [#keyPath(T.favorite): true]
        batchUpdate.affectedStores = viewContext.persistentStoreCoordinator?.persistentStores
        batchUpdate.resultType = .updatedObjectsCountResultType
        
        do {
          let batchResult =
            try viewContext.execute(batchUpdate)
              as! NSBatchUpdateResult
//          print("Records updated \(batchResult.result!)")
        } catch let error as NSError {
//          print("Could not update \(error), \(error.userInfo)")
        }
    }
    
    func removeMedicinesOlderThan(days: Int) {
        let privateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = viewContext.persistentStoreCoordinator
        // Calculate the limit date for a record to be valid by using the days parameter of your method:
        let limitDate = Calendar.current.date(byAdding: .day, value: -days, to: Date())
        // Create a predicate that match this date:
        let predicate = NSPredicate(format: "createdDate <= %@", limitDate! as NSDate)
        // Initialize the NSFetchRequest:
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        // Add the predicate to it:
        fetchRequest.predicate = predicate
        // Initialize your NSBatchDeleteRequest using your fetch request:
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        // Perform the delete operation asynchronously:
        privateContext.perform {
            do {
                // Try executing the batch request:
                try privateContext.execute(batchDeleteRequest)
                if privateContext.hasChanges {
                    // Reflect the changes if anything changed:
                    try privateContext.save()
                }
            }
            catch let error {
                // Handle the error here
                print(error)
            }
        }
    }
}
