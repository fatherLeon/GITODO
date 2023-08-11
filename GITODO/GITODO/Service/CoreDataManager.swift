//
//  CoreDataManager.swift
//  GITODO
//
//  Created by 강민수 on 2023/08/11.
//

import CoreData
import Foundation

final class CoreDataManager {
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
    
    func saveContext(interaction: Interactionable) throws {
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
}
