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
    
    private static let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Task")
        
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
    
    func saveTodo(year: Int, month: Int, day: Int, hour: Int, minute: Int, title: String, memo: String) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "Todo", in: context),
              let todo = NSManagedObject(entity: entity, insertInto: context) as? Todo else {
            throw DBError.creationError
        }
        
        let predicate = NSPredicate(format: "id == %@", "\(year)-\(month)-\(day)")
        let request = Task.fetchRequest()
        
        request.predicate = predicate
        
        guard let result = try context.fetch(request).first else {
            throw DBError.fetchError
        }
        
        todo.setValue(hour, forKey: "hour")
        todo.setValue(minute, forKey: "minute")
        todo.setValue(title, forKey: "title")
        todo.setValue(memo, forKey: "memo")
        
        result.addToTodos(todo)
        
        do {
            try context.save()
        } catch {
            print("TodoError - \(error)")
            throw DBError.creationError
        }
    }
    
    func saveTask(year: Int, month: Int, day: Int, isCommit: Bool = false) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: "Task", in: context) else {
            throw DBError.creationError
        }
        
        let object = NSManagedObject(entity: entity, insertInto: context)
        
        object.setValue(year, forKey: "year")
        object.setValue(month, forKey: "month")
        object.setValue(day, forKey: "day")
        object.setValue(isCommit, forKey: "isCommit")
        object.setValue("\(year)-\(month)-\(day)", forKey: "id")
        
        do {
            try context.save()
        } catch {
            print("TaskError - \(error)")
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
