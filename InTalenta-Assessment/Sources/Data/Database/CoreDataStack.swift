//
//  CoreDataStack.swift
//  InTalenta-Assessment
//
//  Created by Yefga on 13/11/23.
//

import Foundation
import CoreData

class CoreDataStack {

    static let shared = CoreDataStack()
    
    lazy var viewContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Database")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    
    func saveContext() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                fatalError("Unresolved error \(error)")
            }
        }
    }
}


extension CoreDataStack {
    /// Save NSManageObject model to Core Data
    func createObject() async throws {
        try viewContext.save()
    }
    
    /// Read NSManageObject model from Core Data, return in list
    func readObject<T: NSManagedObject>(_ object: T.Type, entityName: String) async throws -> [T] {
        let request = NSFetchRequest<T>(entityName: entityName)
        return try viewContext.fetch(request)
    }
    
    /// Delete NSManageObject model from Core Data
    func deleteObject<T: NSManagedObject>(_ object: T) async throws {
        viewContext.delete(object)
        try viewContext.save()
    }
    
    func filterObjects<T: NSManagedObject>(_ object: T.Type, entityName: String, attributeName: String, attributeValue: Any) async throws -> [T] {
        let request = NSFetchRequest<T>(entityName: entityName)
        let predicate = NSPredicate(format: "%K == %@", argumentArray: [attributeName, attributeValue])
        request.predicate = predicate
        return try viewContext.fetch(request)
    }
}
