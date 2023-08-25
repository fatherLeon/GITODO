//
//  CoreDataManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/11.
//

import CoreData
import Foundation

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    private static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Todo")
        
        container.loadPersistentStores { desc, error in
            if let error = error as NSError? {
                fatalError("\(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private let context: NSManagedObjectContext = CoreDataManager.persistentContainer.viewContext
    
    func save(_ data: Interactionable) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: type(of: data).entityName, in: context) else {
            throw DBError.creationError
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        let mirroredData = Mirror(reflecting: data)
        
        for child in mirroredData.children {
            guard let label = child.label else { continue }
            object.setValue(child.value, forKey: label)
        }
        
        try context.save()
    }
    
    func fetch(_ type: Interactionable.Type) throws -> [Interactionable] {
        let request = type.entityType.fetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: type.entityName, in: context)
        
        request.entity = entity
        
        guard let fetchedData = try context.fetch(request) as? [NSManagedObject] else {
            throw DBError.fetchError
        }
        
        return fetchedData.compactMap { object in
            return type.transform(object)
        }
    }
    
    func search(_ id: String, type: Interactionable.Type) throws -> [Interactionable] {
        let request = type.entityType.fetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: type.entityName, in: context)
        
        request.entity = entity
        request.predicate = NSPredicate(format: "id.length > 0 AND id == %@", id)
        
        do {
            guard let results = try context.fetch(request) as? [NSManagedObject] else {
                return []
            }
            
            return results.compactMap { object in
                return type.transform(object)
            }
        } catch {
            throw DBError.fetchError
        }
    }
    
    func searchOne(_ id: String, type: Interactionable.Type) throws -> Interactionable {
        let request = type.entityType.fetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: type.entityName, in: context)
        
        request.entity = entity
        request.predicate = NSPredicate(format: "id.length > 0 AND id == %@", id)
        
        do {
            guard let results = try context.fetch(request) as? [NSManagedObject],
                  let result = results.first,
                  let transformedResult = type.transform(result) else {
                throw DBError.fetchError
            }
            
            return transformedResult
        } catch {
            throw DBError.fetchError
        }
    }
    
    func search(_ storedDate: Date, type: Interactionable.Type) throws -> NSManagedObject {
        let request = type.entityType.fetchRequest()
        let entity = NSEntityDescription.entity(forEntityName: type.entityName, in: context)
        
        request.entity = entity
        request.predicate = NSPredicate(format: "storedDate == %@", storedDate as NSDate)
        
        do {
            guard let result = try context.fetch(request).first as? NSManagedObject else {
                throw DBError.fetchError
            }
            
            return result
        } catch {
            throw DBError.fetchError
        }
    }
    
    func update(storedDate: Date, data: Interactionable, type: Interactionable.Type) throws {
        guard let object = try? search(storedDate, type: type) else { return }
        
        let mirroredData = Mirror(reflecting: data)
        
        for child in mirroredData.children {
            guard let label = child.label else { continue }
            object.setValue(child.value, forKey: label)
        }
        
        do {
            try context.save()
        } catch {
            throw DBError.updateError
        }
    }
    
    func delete(storedDate: Date, type: Interactionable.Type) throws {
        do {
            let object = try search(storedDate, type: type)
            context.delete(object)
            
            try context.save()
        } catch {
            throw DBError.deleteError
        }
    }
    
    func removeAll(type: Interactionable.Type) throws {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: type.entityName)
        let deletedRequest = NSBatchDeleteRequest(fetchRequest: request)
        
        do {
            try context.execute(deletedRequest)
        } catch {
            throw DBError.deleteError
        }
    }
}
