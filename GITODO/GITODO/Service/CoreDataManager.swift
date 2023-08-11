//
//  CoreDataManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/11.
//

import CoreData
import Foundation

enum EntityType {
    case task
    case todo
    
    var entityName: String {
        switch self {
        case .task:
            return "Task"
        case .todo:
            return "Todo"
        }
    }
    
    var entityType: NSManagedObject.Type {
        switch self {
        case .task:
            return Task.self
        case .todo:
            return Todo.self
        }
    }
}

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private init() { }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Task")
        
        container.loadPersistentStores { desc, error in
            if let error = error as NSError? {
                fatalError("\(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    private var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func save(_ interaction: Interactionable) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: interaction.entityName, in: context) else {
            throw DBError.creationError
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        
        for (label, value) in interaction.getProperties() {
            object.setValue(value, forKey: label)
        }
        
        do {
            try context.save()
        } catch {
            throw DBError.saveError
        }
    }
    
    func fetch(by date: Date, in entityType: EntityType) throws -> [NSManagedObject] {
        let predicate = NSPredicate(format: "date == %@", date as NSDate)
        let request = entityType.entityType.fetchRequest()
        
        request.predicate = predicate
        
        guard let results = try context.fetch(request) as? [NSManagedObject] else {
            throw DBError.fetchError
        }
        
        return results
    }
}
