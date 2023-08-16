//
//  CoreDataManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/11.
//

import CoreData
import Foundation

protocol Interactionable {
    var id: String { get set }
    static var entityType: NSManagedObject.Type { get set }
    static var entityName: String { get set }
    
    func transform() -> NSManagedObject
    static func transform(_ data: NSManagedObject) -> Interactionable?
}

struct TodoObject: Interactionable {
    static var entityType: NSManagedObject.Type = Todo.self
    static var entityName: String = "Todo"
    
    var id: String
    let year: Int16
    let month: Int16
    let day: Int16
    let hour: Int16
    let minute: Int16
    let title: String
    let memo: String
    
    init(year: Int16, month: Int16, day: Int16, hour: Int16, minute: Int16, title: String, memo: String) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
        self.id = "\(year)-\(month)-\(day)"
        self.title = title
        self.memo = memo
    }
    
    func transform() -> NSManagedObject {
        let todo = Todo()
        
        todo.hour = hour
        todo.minute = minute
        todo.title = title
        todo.memo = memo
        
        return todo
    }
    
    static func transform(_ data: NSManagedObject) -> Interactionable? {
        guard let data = data as? Todo,
              let title = data.title,
              let memo = data.memo else { return nil }
        
        return TodoObject(year: data.year, month: data.month, day: data.day, hour: data.hour, minute: data.minute, title: title, memo: memo)
    }
}

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
    
    private var context: NSManagedObjectContext {
        return CoreDataManager.persistentContainer.viewContext
    }
    
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
    
    func update() {
        
    }
}
